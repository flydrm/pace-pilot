import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart' as domain;

import 'ai_evidence_answer.dart';
import 'ai_note_draft.dart';

class OpenAiCompatibleClient {
  OpenAiCompatibleClient({Dio? dio}) : _dio = dio;

  final Dio? _dio;

  Future<void> testConnection({required domain.AiProviderConfig config}) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final dio = _dioWithConfig(config);
    try {
      await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'temperature': 0.0,
          'max_tokens': 1,
          'messages': const [
            {'role': 'user', 'content': 'ping'},
          ],
        },
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    }
  }

  Future<List<String>> breakdownToTasks({
    required domain.AiProviderConfig config,
    required String input,
    int maxItems = 12,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      throw const AiClientException('请输入要拆解的一句话');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个专业的任务拆解助手。',
                '把用户的一段话拆成 3-12 条可执行的待办标题。',
                '输出必须是严格 JSON：一个字符串数组，例如：["任务1","任务2"]。',
                '不要输出 Markdown，不要代码块，不要多余解释。',
              ].join('\n'),
            },
            {'role': 'user', 'content': trimmed},
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final items = _parseJsonStringList(content);
      final normalized = items
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
      if (normalized.isEmpty) {
        throw const AiClientException('模型未返回可解析的任务列表');
      }

      final unique = <String>[];
      for (final item in normalized) {
        if (!unique.contains(item)) unique.add(item);
        if (unique.length >= maxItems) break;
      }
      return unique;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确（无法解析 JSON）');
    }
  }

  Future<AiNoteDraft> draftNoteFromInput({
    required domain.AiProviderConfig config,
    required String input,
    int maxTags = 8,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final raw = input.trim();
    if (raw.isEmpty) {
      throw const AiClientException('请输入要整理的内容');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个工作速记整理助手。',
                '你只能基于用户输入整理与结构化，不得添加任何用户未提供的新事实。',
                '如果需要补充信息，请使用“待补：...”占位，不要自行编造。',
                '风格：克制、商务、稳重；优先用清晰的小标题与要点。',
                '输出必须是严格 JSON 对象，且仅包含以下键：',
                '{"title": string, "body": string, "tags": string[]}',
                '不要输出 Markdown、不要代码块、不要多余解释。',
                'tags 0–8 个，使用简短中文标签（例如：周报、会议纪要、对齐、项目X）。',
              ].join('\n'),
            },
            {'role': 'user', 'content': raw},
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final obj = _parseJsonObject(content);

      final title = (obj['title'] as String?)?.trim() ?? '';
      final body = (obj['body'] as String?)?.trimRight() ?? '';
      final tags = _normalizeTags(obj['tags'], maxTags: maxTags);

      final safeTitle = title.isEmpty ? _fallbackTitle(raw) : title;
      final safeBody = body.trim().isEmpty ? raw : body;

      return AiNoteDraft(title: safeTitle, body: safeBody, tags: tags);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确（无法解析 JSON）');
    }
  }

  List<String> _normalizeTags(Object? raw, {required int maxTags}) {
    final tags = <String>[];
    void addTag(String tag) {
      final t = tag.trim();
      if (t.isEmpty) return;
      if (tags.contains(t)) return;
      tags.add(t);
    }

    if (raw is List) {
      for (final t in raw) {
        if (t is String) addTag(t);
        if (tags.length >= maxTags) break;
      }
    } else if (raw is String) {
      for (final t in raw.split(',')) {
        addTag(t);
        if (tags.length >= maxTags) break;
      }
    }
    return tags;
  }

  String _fallbackTitle(String raw) {
    final firstLine = raw.split('\n').first.trim();
    if (firstLine.isEmpty) return '速记';
    return firstLine.length <= 18
        ? firstLine
        : '${firstLine.substring(0, 18)}…';
  }

  Future<String> summarizeNote({
    required domain.AiProviderConfig config,
    required String title,
    required String body,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final noteBody = body.trim();
    if (noteBody.isEmpty) {
      throw const AiClientException('笔记正文为空');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个专业的笔记总结助手。',
                '请将用户提供的笔记总结为 5–8 条要点。',
                '风格：克制、商务、稳重；不输出情绪化表达。',
                '只输出总结内容本身，不要额外解释；不要输出代码块。',
              ].join('\n'),
            },
            {
              'role': 'user',
              'content': ['笔记标题：$title', '', '笔记正文：', noteBody].join('\n'),
            },
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final summary = _stripCodeFences(content).trim();
      if (summary.isEmpty) {
        throw const AiClientException('模型未返回可用总结');
      }
      return summary;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确');
    }
  }

  Future<List<String>> extractActionItemsFromNote({
    required domain.AiProviderConfig config,
    required String title,
    required String body,
    int maxItems = 12,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final noteBody = body.trim();
    if (noteBody.isEmpty) {
      throw const AiClientException('笔记正文为空');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个行动项提取助手。',
                '从用户的笔记中提取 3-12 条可执行的下一步行动项标题。',
                '输出必须是严格 JSON：一个字符串数组，例如：["行动项1","行动项2"]。',
                '不要输出 Markdown，不要代码块，不要多余解释。',
              ].join('\n'),
            },
            {
              'role': 'user',
              'content': ['笔记标题：$title', '', '笔记正文：', noteBody].join('\n'),
            },
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final items = _parseJsonStringList(content);
      final normalized = items
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
      if (normalized.isEmpty) {
        throw const AiClientException('模型未返回可解析的行动项列表');
      }

      final unique = <String>[];
      for (final item in normalized) {
        if (!unique.contains(item)) unique.add(item);
        if (unique.length >= maxItems) break;
      }
      return unique;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确（无法解析 JSON）');
    }
  }

  Future<String> generateProgressNote({
    required domain.AiProviderConfig config,
    required String taskTitle,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final title = taskTitle.trim();
    if (title.isEmpty) {
      throw const AiClientException('任务标题为空');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个进展记录助手。',
                '你只能基于用户提供的内容输出，禁止编造任何新事实/新进展。',
                '当信息不足时，必须用“待补：...”标记缺失信息，不要猜测。',
                '输出为 1 句话（最多 40 字），风格：克制、商务、稳重。',
                '不要输出 Markdown、不要代码块、不要多余解释。',
              ].join('\n'),
            },
            {
              'role': 'user',
              'content': [
                '任务：$title',
                '用户未提供任何进展细节，请给出一条可保存的进展记录（包含“待补：...”）。',
              ].join('\n'),
            },
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final generated = _stripCodeFences(content).trim();
      if (generated.isEmpty) {
        throw const AiClientException('模型未返回可用内容');
      }
      return generated;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确');
    }
  }

  Future<String> rewriteNoteForSharing({
    required domain.AiProviderConfig config,
    required String title,
    required String body,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final noteBody = body.trim();
    if (noteBody.isEmpty) {
      throw const AiClientException('笔记正文为空');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个“对外同步文案”助手。',
                '请将用户提供的笔记改写为可对外同步的一段文本（发给外部干系人/跨团队同步）。',
                '只使用笔记中提供的信息，禁止编造任何新事实/新结论/新进展。',
                '如果关键信息缺失，用“待补：...”标记，不要猜测。',
                '风格：克制、商务、稳重；优先结构化表达。',
                '建议结构：一句话摘要 / 进展 / 风险或阻塞 / 下一步。',
                '只输出正文内容本身，不要额外解释；不要输出代码块。',
              ].join('\n'),
            },
            {
              'role': 'user',
              'content': ['笔记标题：$title', '', '笔记正文：', noteBody].join('\n'),
            },
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final rewritten = _stripCodeFences(content).trim();
      if (rewritten.isEmpty) {
        throw const AiClientException('模型未返回可用内容');
      }
      return rewritten;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确');
    }
  }

  Future<String> polishProgressNote({
    required domain.AiProviderConfig config,
    required String taskTitle,
    required String input,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }

    final raw = input.trim();
    if (raw.isEmpty) {
      throw const AiClientException('请输入要优化的进展内容');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个进展记录润色助手。',
                '只对用户输入进行措辞优化与结构压缩，不得添加任何新事实或新进展。',
                '输出为 1 句话（最多 40 字），风格：克制、商务、稳重。',
                '不要输出 Markdown、不要代码块、不要多余解释。',
              ].join('\n'),
            },
            {
              'role': 'user',
              'content': ['任务：$taskTitle', '原始进展：$raw'].join('\n'),
            },
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final polished = _stripCodeFences(content).trim();
      if (polished.isEmpty) {
        throw const AiClientException('模型未返回可用内容');
      }
      return polished;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确');
    }
  }

  Future<AiEvidenceAnswer> askWithEvidence({
    required domain.AiProviderConfig config,
    required String question,
    required List<String> evidence,
    AiCancelToken? cancelToken,
  }) async {
    final apiKey = config.apiKey?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiClientException('请先填写 apiKey');
    }
    final model = config.model.trim();
    if (model.isEmpty) {
      throw const AiClientException('请先填写 model');
    }
    final q = question.trim();
    if (q.isEmpty) {
      throw const AiClientException('请输入问题');
    }
    if (evidence.isEmpty) {
      throw const AiClientException('请先选择证据');
    }

    final dio = _dioWithConfig(config);
    try {
      final response = await dio.post(
        '/chat/completions',
        cancelToken: cancelToken?._token,
        data: {
          'model': model,
          'temperature': 0.0,
          'messages': [
            {
              'role': 'system',
              'content': [
                '你是一个 Evidence-first 助手。',
                '你只能基于用户提供的证据回答，禁止编造。',
                '回答语言与问题一致（默认中文）。',
                '如果证据不足以回答，就设置 insufficientEvidence=true，并在 answer 中明确说明不足，以及需要补充什么。',
                '输出必须是严格 JSON 对象，且仅包含以下键：',
                '{"answer": string, "citations": number[], "insufficientEvidence": boolean}',
                'citations 只能引用证据编号（例如 [1,2]），不得引用不存在的编号。',
                '当 insufficientEvidence=false 时，citations 必须为 2–5 个编号（去重、升序）。',
                '当 insufficientEvidence=true 时，citations 必须为空数组。',
              ].join('\n'),
            },
            {
              'role': 'user',
              'content': ['问题：', q, '', '证据（按编号引用）：', ...evidence].join('\n'),
            },
          ],
        },
      );

      final content = _extractFirstMessageContent(response.data);
      final obj = _parseJsonObject(content);

      final answer = (obj['answer'] as String?)?.trim() ?? '';
      final insufficient = obj['insufficientEvidence'] == true;
      final citationsRaw = obj['citations'];
      final citations = <int>[];
      if (citationsRaw is List) {
        for (final c in citationsRaw) {
          if (c is int) citations.add(c);
          if (c is double) citations.add(c.toInt());
        }
      }

      if (answer.isEmpty) {
        throw const AiClientException('模型未返回可用回答');
      }

      return AiEvidenceAnswer(
        answer: answer,
        citations: citations.toSet().toList()..sort(),
        insufficientEvidence: insufficient,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw const AiClientCancelledException();
      }
      throw AiClientException(_readableError(e));
    } on FormatException catch (_) {
      throw const AiClientException('模型返回格式不正确（无法解析 JSON）');
    }
  }

  Dio _dioWithConfig(domain.AiProviderConfig config) {
    final base = _normalizeBaseUrl(config.baseUrl);
    final headers = <String, Object?>{'Content-Type': 'application/json'};
    final apiKey = config.apiKey?.trim();
    if (apiKey != null && apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: base,
        headers: headers,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    final injected = _dio;
    if (injected != null) {
      dio.httpClientAdapter = injected.httpClientAdapter;
      dio.interceptors.addAll(injected.interceptors);
    }
    return dio;
  }

  String _normalizeBaseUrl(String baseUrl) {
    var url = baseUrl.trim();
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.endsWith('/v1')) return url;
    return '$url/v1';
  }

  String _extractFirstMessageContent(Object? data) {
    if (data is! Map) {
      throw const FormatException('Unexpected response type');
    }
    final choices = data['choices'];
    if (choices is! List || choices.isEmpty) {
      throw const FormatException('Missing choices');
    }
    final first = choices.first;
    if (first is! Map) throw const FormatException('Invalid choice');
    final message = first['message'];
    if (message is Map && message['content'] is String) {
      return message['content'] as String;
    }
    final text = first['text'];
    if (text is String) return text;
    throw const FormatException('Missing content');
  }

  List<String> _parseJsonStringList(String raw) {
    final text = _stripCodeFences(raw).trim();
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    final slice = (start >= 0 && end >= 0 && end > start)
        ? text.substring(start, end + 1)
        : text;
    final decoded = jsonDecode(slice);
    if (decoded is List) {
      return decoded.whereType<String>().toList();
    }
    throw const FormatException('Not a JSON list');
  }

  Map<String, Object?> _parseJsonObject(String raw) {
    final text = _stripCodeFences(raw).trim();
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    final slice = (start >= 0 && end >= 0 && end > start)
        ? text.substring(start, end + 1)
        : text;
    final decoded = jsonDecode(slice);
    if (decoded is Map) {
      return decoded.map((k, v) => MapEntry(k.toString(), v));
    }
    throw const FormatException('Not a JSON object');
  }

  String _stripCodeFences(String text) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('```')) return text;
    final firstNewline = trimmed.indexOf('\n');
    if (firstNewline < 0) return text;
    final lastFence = trimmed.lastIndexOf('```');
    if (lastFence <= firstNewline) return text;
    return trimmed.substring(firstNewline + 1, lastFence);
  }

  String _readableError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401 || status == 403) {
      return '鉴权失败：请检查 apiKey 是否正确';
    }
    if (status == 404) {
      return '接口不存在：请检查 baseUrl 是否正确（应为 OpenAI 兼容的 /v1）';
    }
    if (status != null) {
      return '请求失败（HTTP $status）';
    }
    return '连接失败：${e.message ?? '未知错误'}';
  }
}

class AiClientException implements Exception {
  const AiClientException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AiClientCancelledException implements Exception {
  const AiClientCancelledException();

  @override
  String toString() => '已取消';
}

class AiCancelToken {
  AiCancelToken();

  final CancelToken _token = CancelToken();

  bool get isCancelled => _token.isCancelled;

  void cancel([String? reason]) {
    if (_token.isCancelled) return;
    _token.cancel(reason);
  }
}

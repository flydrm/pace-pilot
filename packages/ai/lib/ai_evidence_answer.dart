class AiEvidenceAnswer {
  const AiEvidenceAnswer({
    required this.answer,
    required this.citations,
    required this.insufficientEvidence,
  });

  final String answer;
  final List<int> citations;
  final bool insufficientEvidence;
}


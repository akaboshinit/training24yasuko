class Counter {
  final int count;

  Counter({required this.count});

  factory Counter.fromFirestore(dynamic firestoreData) {
    return Counter(
      count: firestoreData['count'] ?? 0,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../models/ticket.dart';

/// This file demonstrates the DIFFERENCE between WITH and WITHOUT Equatable
/// Use this as a reference to understand the benefits!

// ============================================================================
// EXAMPLE 1: WITHOUT EQUATABLE
// ============================================================================

class TicketStateWithoutEquatable {
  final List<dynamic> tickets;
  
  const TicketStateWithoutEquatable({required this.tickets});
  
  // No equals operator override!
  // Dart will use default comparison (reference equality)
}

void demonstrateWithoutEquatable() {
  print('━━━ WITHOUT EQUATABLE ━━━');
  
  final ticket1 = {'id': 1, 'title': 'Movie'};
  final ticket2 = {'id': 2, 'title': 'Concert'};
  
  final state1 = TicketStateWithoutEquatable(tickets: [ticket1, ticket2]);
  final state2 = TicketStateWithoutEquatable(tickets: [ticket1, ticket2]);
  
  print('State 1: ${state1.tickets}');
  print('State 2: ${state2.tickets}');
  print('Are they equal? ${state1 == state2}');  // 😞 FALSE!
  print('Result: UI will REBUILD even though data is the same!\n');
}

// ============================================================================
// EXAMPLE 2: WITH EQUATABLE (Manual Implementation)
// ============================================================================

class TicketStateWithManualEquatable {
  final List<dynamic> tickets;
  
  const TicketStateWithManualEquatable({required this.tickets});
  
  // Manually override == operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TicketStateWithManualEquatable) return false;
    
    // Compare the tickets list
    if (tickets.length != other.tickets.length) return false;
    for (int i = 0; i < tickets.length; i++) {
      if (tickets[i] != other.tickets[i]) return false;
    }
    return true;
  }
  
  // Must override hashCode when overriding ==
  @override
  int get hashCode => tickets.hashCode;
}

void demonstrateWithManualEquatable() {
  print('━━━ WITH MANUAL EQUATABLE ━━━');
  
  final ticket1 = {'id': 1, 'title': 'Movie'};
  final ticket2 = {'id': 2, 'title': 'Concert'};
  
  final state1 = TicketStateWithManualEquatable(tickets: [ticket1, ticket2]);
  final state2 = TicketStateWithManualEquatable(tickets: [ticket1, ticket2]);
  
  print('State 1: ${state1.tickets}');
  print('State 2: ${state2.tickets}');
  print('Are they equal? ${state1 == state2}');  // 😊 TRUE!
  print('Result: UI will NOT rebuild - smart comparison!\n');
  print('BUT: We had to write a lot of boilerplate code! 😓\n');
}

// ============================================================================
// EXAMPLE 3: WITH EQUATABLE PACKAGE (Best Solution!)
// ============================================================================



class TicketStateWithEquatable extends Equatable {
  final List<Ticket> tickets;
  
  const TicketStateWithEquatable({required this.tickets});
  
  // Just list the properties to compare - Equatable does the rest!
  @override
  List<Object?> get props => [tickets];
  // That's it! No need to manually write == and hashCode! 🎉
}

void demonstrateWithEquatablePackage() {
  print('━━━ WITH EQUATABLE PACKAGE ━━━');
  
  final ticket1 = Ticket(
    id: 1,
    title: 'Movie',
    description: 'Action movie',
    price: 100,
    date: DateTime(2024, 1, 1),
    imageUrl: 'url',
  );
  
  final ticket2 = Ticket(
    id: 2,
    title: 'Concert',
    description: 'Rock concert',
    price: 200,
    date: DateTime(2024, 1, 2),
    imageUrl: 'url',
  );
  
  final state1 = TicketStateWithEquatable(tickets: [ticket1, ticket2]);
  final state2 = TicketStateWithEquatable(tickets: [ticket1, ticket2]);
  
  print('State 1: ${state1.tickets.length} tickets');
  print('State 2: ${state2.tickets.length} tickets');
  print('Are they equal? ${state1 == state2}');  // 😊 TRUE!
  print('Result: UI will NOT rebuild - smart comparison!');
  print('AND: Minimal code needed! Just one line (props)! 🚀\n');
}

// ============================================================================
// REAL-WORLD SCENARIO: Pull-to-Refresh
// ============================================================================

class RefreshScenario {
  void demonstrateRefreshWithoutEquatable() {
    print('━━━ REFRESH SCENARIO: WITHOUT EQUATABLE ━━━');
    print('1. User sees list of 50 tickets');
    print('2. User pulls to refresh');
    print('3. API returns same 50 tickets (no changes)');
    print('4. BLoC emits new state');
    print('5. Flutter compares: old == new? FALSE! (different objects)');
    print('6. ❌ UI rebuilds all 50 cards');
    print('7. User sees flicker/animation');
    print('8. Frame drops on slower devices');
    print('9. Poor user experience! 😞\n');
  }
  
  void demonstrateRefreshWithEquatable() {
    print('━━━ REFRESH SCENARIO: WITH EQUATABLE ━━━');
    print('1. User sees list of 50 tickets');
    print('2. User pulls to refresh');
    print('3. API returns same 50 tickets (no changes)');
    print('4. BLoC emits new state');
    print('5. Equatable compares: old.props == new.props? TRUE!');
    print('6. ✅ UI does NOT rebuild');
    print('7. Smooth, no flicker');
    print('8. Better performance');
    print('9. Happy user! 😊\n');
  }
}

// ============================================================================
// TESTING SCENARIO
// ============================================================================

void demonstrateTesting() {
  print('━━━ TESTING WITH EQUATABLE ━━━');
  
  final ticket = Ticket(
    id: 1,
    title: 'Concert',
    description: 'Live music',
    price: 150,
    date: DateTime(2024, 6, 15),
    imageUrl: 'image.jpg',
  );
  
  final expectedState = TicketStateWithEquatable(tickets: [ticket]);
  final actualState = TicketStateWithEquatable(tickets: [ticket]);
  
  // This assertion works because of Equatable!
  if (expectedState == actualState) {
    print('✅ Test PASSED: States are equal');
  } else {
    print('❌ Test FAILED: States are different');
  }
  
  print('Without Equatable, this test would always fail!\n');
}

// ============================================================================
// MAIN DEMO
// ============================================================================

void main() {
  print('═════════════════════════════════════════════════════════════');
  print('       EQUATABLE DEMONSTRATION IN FLUTTER BLOC');
  print('═════════════════════════════════════════════════════════════\n');
  
  // Run all demonstrations
  demonstrateWithoutEquatable();
  demonstrateWithManualEquatable();
  demonstrateWithEquatablePackage();
  
  final scenario = RefreshScenario();
  scenario.demonstrateRefreshWithoutEquatable();
  scenario.demonstrateRefreshWithEquatable();
  
  demonstrateTesting();
  
  print('═════════════════════════════════════════════════════════════');
  print('CONCLUSION:');
  print('✅ Equatable prevents unnecessary UI rebuilds');
  print('✅ Minimal code needed (just define props)');
  print('✅ Better performance and UX');
  print('✅ Easier testing');
  print('✅ Essential for BLoC pattern in Flutter!');
  print('═════════════════════════════════════════════════════════════');
}

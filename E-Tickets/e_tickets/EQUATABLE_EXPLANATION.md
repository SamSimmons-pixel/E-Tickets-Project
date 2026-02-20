# 🎯 Equatable in BLoC - Visual Explanation

## Why We Need Object Comparison in BLoC

### ❌ WITHOUT Equatable

```dart
// WITHOUT Equatable
class TicketState {
  final List<Ticket> tickets;
  TicketState({required this.tickets});
}

// In BLoC:
emit(TicketState(tickets: [ticket1, ticket2]));  // First emit
emit(TicketState(tickets: [ticket1, ticket2]));  // Second emit with SAME data

// What happens?
// Flutter compares: oldState == newState
// Result: false (different objects in memory)
// 😞 UI REBUILDS even though data is identical!
```

### ✅ WITH Equatable

```dart
// WITH Equatable
class TicketState extends Equatable {
  final List<Ticket> tickets;

  const TicketState({required this.tickets});

  @override
  List<Object?> get props => [tickets];  // 👈 This enables comparison!
}

// In BLoC:
emit(TicketState(tickets: [ticket1, ticket2]));  // First emit
emit(TicketState(tickets: [ticket1, ticket2]));  // Second emit with SAME data

// What happens?
// Equatable compares: oldState.props == newState.props
// Result: true (same tickets!)
// 😊 UI DOES NOT REBUILD - Better performance!
```

---

## Real-World Example: Pull-to-Refresh

### Scenario: User pulls to refresh, but data hasn't changed

```dart
// User's ticket list
Initial state: TicketLoaded([
  Ticket(id: 1, title: "Kimi no nawa", price: 100),
  Ticket(id: 2, title: "Ticket 2", price: 200),
])

// User pulls to refresh
// API returns same tickets
// BLoC emits new state:
New state: TicketLoaded([
  Ticket(id: 1, title: "Kimi no nawa", price: 100),
  Ticket(id: 2, title: "Ticket 2", price: 200),
])
```

#### WITHOUT Equatable:

```
1. BLoC emits new TicketLoaded state
2. Flutter checks: old == new?
3. Result: FALSE (different objects)
4. 🎨 UI REBUILDS → ListView rebuilds all cards
5. User sees flicker/animation
6. Poor UX! 😞
```

#### WITH Equatable:

```
1. BLoC emits new TicketLoaded state
2. Equatable compares props: [tickets] == [tickets]?
3. Each Ticket also uses Equatable!
4. Result: TRUE (identical data)
5. 🚫 UI DOES NOT REBUILD
6. Smooth, no flicker! 😊
```

---

## How Equatable Works in Your Code

### 1. In Models (Ticket)

```dart
class Ticket extends Equatable {
  final int id;
  final String title;
  // ...

  @override
  List<Object?> get props => [id, title, description, price, date, imageUrl];
  //                          ^ All fields used for comparison
}
```

This means:

```dart
Ticket t1 = Ticket(id: 1, title: "Movie", price: 100, ...);
Ticket t2 = Ticket(id: 1, title: "Movie", price: 100, ...);

t1 == t2  // TRUE! Same values = equal objects
```

### 2. In States (TicketState)

```dart
class TicketLoaded extends TicketState {
  final List<Ticket> tickets;

  const TicketLoaded({required this.tickets});

  @override
  List<Object?> get props => [tickets];
  //                          ^ List of tickets used for comparison
}
```

This means:

```dart
TicketLoaded s1 = TicketLoaded(tickets: [t1, t2]);
TicketLoaded s2 = TicketLoaded(tickets: [t1, t2]);

s1 == s2  // TRUE! Same ticket list = equal states
```

### 3. In Events (TicketEvent)

```dart
class LoadTicketById extends TicketEvent {
  final int ticketId;

  const LoadTicketById({required this.ticketId});

  @override
  List<Object?> get props => [ticketId];
}
```

This helps prevent duplicate event processing:

```dart
LoadTicketById e1 = LoadTicketById(ticketId: 1);
LoadTicketById e2 = LoadTicketById(ticketId: 1);

e1 == e2  // TRUE! Same event, don't process twice
```

---

## Performance Impact

### Example: Ticket List with 50 items

| Scenario                      | Without Equatable        | With Equatable      |
| ----------------------------- | ------------------------ | ------------------- |
| Pull to refresh (no new data) | Rebuilds 50 cards        | Rebuilds 0 cards    |
| Load same data twice          | Rebuilds entire list     | No rebuild          |
| BLoC state update frequency   | May rebuild too often    | Smart rebuilds only |
| Frame drops                   | Possible on slow devices | Smooth 60fps        |

---

## Testing Benefits

With Equatable, testing is MUCH easier:

```dart
test('should emit same state when data unchanged', () {
  final state1 = TicketLoaded(tickets: [ticket1, ticket2]);
  final state2 = TicketLoaded(tickets: [ticket1, ticket2]);

  // WITHOUT Equatable: This would FAIL
  // WITH Equatable: This PASSES! ✅
  expect(state1, state2);
});
```

---

## When Does Comparison Happen?

### In BlocBuilder:

```dart
BlocBuilder<TicketBloc, TicketState>(
  // Called EVERY time BLoC emits a new state
  buildWhen: (previous, current) {
    // Equatable makes this comparison possible!
    return previous != current;  // 👈 Uses Equatable's == operator
  },
  builder: (context, state) {
    // Only called if buildWhen returns true
    return TicketList(state.tickets);
  },
)
```

### In BlocListener:

```dart
BlocListener<TicketBloc, TicketState>(
  // Only listen to specific state changes
  listenWhen: (previous, current) {
    // Only trigger listener if state actually changed
    return previous != current;  // 👈 Uses Equatable
  },
  listener: (context, state) {
    if (state is TicketError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: TicketListView(),
)
```

---

## Summary

### Equatable solves 3 main problems:

1. **Performance**: Prevents unnecessary UI rebuilds
2. **Predictability**: States are compared by value, not reference
3. **Testing**: Easy to verify state equality

### In your Ticket app:

- ✅ `Ticket` model uses Equatable → Can compare tickets
- ✅ `TicketState` uses Equatable → Can compare states
- ✅ `TicketEvent` uses Equatable → Can compare events
- ✅ BLoC can intelligently decide when to rebuild UI
- ✅ Better performance and UX!

---

## Try It Yourself!

Run `TicketListScreen` and watch the console:

1. **Load tickets** → See initial build
2. **Pull to refresh** → See state comparison
3. **Refresh multiple times** → Notice fewer rebuilds with Equatable!

The console will show:

```
🔍 Comparing states:
Previous: TicketLoaded(tickets: [Ticket(id: 1, ...), ...])
Current: TicketLoaded(tickets: [Ticket(id: 1, ...), ...])
Are they equal? true  👈 No rebuild needed!
---
```

Without Equatable, it would always say `false`, causing unnecessary rebuilds!

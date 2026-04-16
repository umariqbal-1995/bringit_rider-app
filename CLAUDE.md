# BringIt Rider App — AI Engineering Instructions

Read the root `CLAUDE.md` first. This file adds rider app-specific directives.

---

## ROLE

You are a senior Flutter engineer on the BringIt rider app. This app is used by delivery riders in the field. It must be fast, reliable, and work under real-world conditions (weak signal, background usage, GPS active). You do not mark a task done without running the app on a simulator and validating the feature.

---

## MANDATORY: TEST EVERY CHANGE

After every code change:
1. Run `flutter run` on iOS or Android simulator
2. Navigate to the affected screen — verify it renders correctly
3. Test the full rider flow for the feature
4. Test with the server running — verify real API responses
5. Test GPS/location features with simulated coordinates if needed
6. Verify Socket.IO events fire and are received correctly for order updates

---

## ARCHITECTURE

```
lib/
├── app/
│   ├── data/
│   │   ├── models/         # Rider, Order, Notification data classes
│   │   ├── providers/      # Dio API provider, GetStorage provider
│   │   └── repositories/   # All API calls — typed, error-handled
│   ├── modules/
│   │   └── <feature>/
│   │       ├── bindings/   # GetX dependency injection
│   │       ├── controllers/ # State + logic
│   │       └── views/      # UI only
│   ├── routes/             # GetX route definitions
│   ├── theme/              # Colors, typography
│   └── utils/              # Constants, helpers
```

**Layer rules:**
- Views are dumb — observe state, call controller methods only
- Controllers manage state, call repositories, handle socket events
- Repositories make all HTTP calls and return typed models

---

## RIDER APP USER FLOWS

The rider uses this app to:
1. **Onboarding** — register, upload documents, get approved
2. **Auth** — OTP login
3. **Home / Dashboard** — toggle availability (online/offline), see assigned orders
4. **Order Accept/Decline** — incoming order notification with pickup details
5. **Navigation Map** — live map showing pickup → dropoff route
6. **Order Status Updates** — mark as picked up, mark as delivered
7. **Earnings** — daily/weekly earnings, per-order breakdown
8. **Analytics** — delivery stats, ratings, performance
9. **Notifications** — new order alerts, system messages
10. **Profile** — personal info, vehicle details, documents

Every feature must be complete end-to-end.

---

## LOCATION & REAL-TIME (CRITICAL)

- Rider location must be broadcast to the backend via Socket.IO while on an active delivery
- The user app displays this location — it must update smoothly
- Location updates: emit `rider:location_update` event with `{ riderId, lat, lng, orderId }`
- When testing location features, use the simulator's location simulation tools
- Background location: must continue sending updates when the app is backgrounded on an active delivery

---

## ORDER STATE MACHINE (RIDER'S PERSPECTIVE)

```
ASSIGNED → rider accepts → PICKED_UP → rider delivers → DELIVERED
         ↘ rider declines → back to store for reassignment
```
- Rider can only see orders assigned to them
- Status transitions must update via REST + emit Socket.IO event
- The user watching their order must see status changes in real time

---

## FIELD-USE UX REQUIREMENTS

Riders use this app while moving, often one-handed:
- Large tap targets (minimum 48x48dp)
- Critical actions (accept, picked up, delivered) must be prominent and single-tap
- No deep navigation for time-sensitive actions
- Maps must load quickly — handle GPS permission denial gracefully
- Show clear feedback if internet drops

---

## RUNNING

```bash
flutter pub get
flutter run
flutter run --release   # for performance testing
```

Notify when done: `tput bel`

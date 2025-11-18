# Mock Mode & Debug Guide

## Overview

This guide explains the current mock/debug infrastructure in the Any Distance iOS app and how to bypass login for testing and development.

## Current Infrastructure

### What Exists

#### 1. Simulator Auto-Setup (`SceneDelegate.swift:45-89`)
Automatically runs when building for simulator:
- Sets test user ID to `"sim"`
- Forces onboarding UI display
- Sets distance unit to miles
- **Note:** Does not mock API calls - still hits real servers

#### 2. Phone Verification Bypass (`OnboardingViewModel.swift:15-127`)
Code exists to skip Twilio phone verification but is **currently disabled**
- Requires uncommenting `DEBUG_APPLE_USER_ID` and `DEBUG_EMAIL`
- Once enabled, skips phone verification step
- Still requires Apple Sign In

#### 3. Debug Configuration Detection (`AppConfiguration.swift`)
- Detects Debug vs Release vs TestFlight builds
- Currently only used for analytics tagging
- Limited functionality

#### 4. Sandbox Credentials (`ExternalService+Keys.swift`)
- Automatically uses sandbox OAuth for Wahoo/Garmin in DEBUG builds
- Status: Active and working

---

## Authentication Flow

```
Apple Sign In (REQUIRED)
    ↓
UserManager.signIn()
    ↓
Edge API lookup by Apple ID
    ↓
CloudKit fallback (requires iCloud account)
    ↓
Twilio Phone Verification (CAN BE BYPASSED)
    ↓
Username selection
    ↓
App ready
```

**Critical:** Apple Sign In is mandatory and cannot be bypassed without significant refactoring.

---

## How to Bypass Login

### Option 1: Enable Phone Verification Bypass (Quickest)

**Time:** 2 minutes | **Effort:** Minimal

1. Open `ADAC/Screens/Onboarding/OnboardingViewModel.swift`
2. Navigate to lines 15-127 (the `debugSkipPhoneVerification` section)
3. Change the nil values to test credentials:

```swift
let DEBUG_APPLE_USER_ID = "test_user_123"  // Change from nil
let DEBUG_EMAIL = "test@example.com"       // Change from nil
```

4. Run the app in simulator
5. When you reach phone verification, these values will bypass it

**Limitations:**
- Still requires Apple Sign In
- Still calls real APIs
- Not suitable for offline development

### Option 2: Add Debug Environment Variable (Medium Effort)

**Time:** 15 minutes | **Effort:** Medium

1. Create a new build scheme for debugging:
   - Xcode → Product → Scheme → Edit Scheme
   - Add environment variable: `MOCK_MODE=1`

2. Check for this variable at app startup:
```swift
let isMockMode = ProcessInfo.processInfo.environment["MOCK_MODE"] == "1"
```

3. Use this flag to:
   - Skip authentication steps
   - Provide test user data
   - Redirect API calls (see Option 3)

### Option 3: Full Mock Mode Implementation (Recommended Long-term)

**Time:** 3-5 days | **Effort:** High

This requires architectural changes:

#### 3a. Service Protocol Abstraction
Create protocols for all services to enable mocking:
```swift
protocol AuthenticationService {
    func signIn() async -> User?
}

protocol APIService {
    func fetchActivities() async -> [Activity]
}
```

#### 3b. URLSession Mock Layer
Use `URLProtocol` to intercept and mock network requests:
```swift
class MockURLProtocol: URLProtocol {
    static var mockResponses: [String: Data] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        return mockResponses[request.url?.absoluteString ?? ""] != nil
    }
    // ... implementation
}
```

#### 3c. Test Data Fixtures
Create mock data files for:
- User profiles
- Activities
- Locations
- API responses

#### 3d. Environment Switching
Add configuration to switch between:
- Production API
- Staging API
- Local mock server
- File-based fixtures

---

## Key Files Reference

| Purpose | File | Lines |
|---------|------|-------|
| Simulator debugging | `SceneDelegate.swift` | 45-89 |
| Phone verification bypass | `OnboardingViewModel.swift` | 15-127 |
| Debug configuration | `AppConfiguration.swift` | - |
| Authentication | `UserManager.swift` | - |
| Sign in flow | `SignInViewController.swift` | - |
| API configuration | `Edge.swift` | - |
| External services | `ExternalService+Keys.swift` | - |

---

## Current Limitations

### Critical Gaps

1. **No Network Mocking** - All API calls hit real servers
2. **No Service Layer Abstraction** - Direct URLSession calls, tight coupling
3. **No Authentication Bypass** - Apple Sign In is mandatory
4. **No Test Data** - Only one mock object exists (MockActivity)
5. **No Environment Switching** - Can't route to different API endpoints
6. **No Test Build Schemes** - Only Debug/Release configurations
7. **No UI Testing Infrastructure** - Missing accessibility identifiers

### What Cannot Be Bypassed Without Major Refactoring

- **Apple Sign In** - This is a fundamental requirement of the app's architecture
- **Network calls** - All API interactions hit real endpoints
- **CloudKit dependency** - Fallback authentication requires iCloud

---

## Recommendations for Development

### Short-term (This Week)
- [ ] Enable phone verification bypass for simulator testing
- [ ] Document test Apple IDs
- [ ] Create test user fixtures

### Medium-term (Next Sprint)
- [ ] Create service protocols for key components
- [ ] Implement URLSession mock layer
- [ ] Add build schemes for different environments

### Long-term (Next Quarter)
- [ ] Full dependency injection setup
- [ ] Comprehensive test data fixtures
- [ ] Mock API server or file-based responses
- [ ] UI automation test infrastructure

---

## Testing Without Full Login

Until full mock mode is implemented, test using:

1. **Real Apple ID + Real Phone** (most reliable)
2. **Simulator with phone bypass enabled** + real Apple ID
3. **TestFlight build** on physical device

---

## Questions?

For more details on authentication implementation, see:
- `UserManager.swift` - Core authentication logic
- `SignInViewController.swift` - Sign-in UI flow
- `OnboardingViewModel.swift` - Onboarding sequence


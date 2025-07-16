// callRespondToOffer.js

// Import necessary Firebase SDK modules
import { initializeApp } from 'firebase/app';
import { getAuth, connectAuthEmulator, signInWithEmailAndPassword } from 'firebase/auth';
import { getFunctions, connectFunctionsEmulator, httpsCallable } from 'firebase/functions';

// --- Configuration ---
// IMPORTANT: Replace with your actual Firebase project config.
// You can find this in your Flutter project's firebase_options.dart
// or in the Firebase console (Project settings > General > Your apps > SDK setup and configuration)
// While emulators might be lenient, using correct values is best practice.
const firebaseConfig = {
    apiKey: 'AIzaSyA87KTZ3RjxZzYi0wUglWWYp-crVbAiFME',
    authDomain: 'nurse-642a7.firebaseapp.com', // Replace (e.g., your-project-id.firebaseapp.com)
    appId: '1:447879962177:android:63e4acccdc88c8031630c0',
    messagingSenderId: '447879962177',
    projectId: 'nurse-642a7',
    storageBucket: 'nurse-642a7.firebasestorage.app',
};

// --- Test Parameters ---
const emulatorHost = "localhost"; // Or "localhost"
const authEmulatorPort = 8080;     // Default port, change if yours is different
const functionsEmulatorPort = 6001; // Default port, change if yours is different
const firestoreEmulatorPort = 9080; // Default port, change if yours is different (needed for functions interacting with firestore)

const nurseEmail = "nurse1@test.com";   // Email of the test nurse created in Emulator UI
const nursePassword = "password";       // Password of the test nurse
const testRequestId = "U3AZH9BY7qqtpS1QKWuN"; // The ID of the serviceRequest doc created in Emulator UI
const testResponse = "rejected";        // Change to "rejected" to test the other path

// --- Script Logic ---

async function runTest() {
  // Initialize Firebase App
  const app = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const functions = getFunctions(app); // Use default region or specify if needed: getFunctions(app, 'your-region')

  // Connect SDKs to Emulators
  console.log(`Connecting to emulators: Auth (${emulatorHost}:${authEmulatorPort}), Functions (${emulatorHost}:${functionsEmulatorPort})`);
  try {
    connectAuthEmulator(auth, `http://${emulatorHost}:${authEmulatorPort}`);
    connectFunctionsEmulator(functions, emulatorHost, functionsEmulatorPort);
    // Note: Firestore interactions within the function will automatically use the
    // FIRESTORE_EMULATOR_HOST environment variable set by 'firebase emulators:start'.
    // If testing Firestore directly from this script, you'd use connectFirestoreEmulator.
  } catch (error) {
    console.error("Error connecting to emulators:", error);
    return;
  }

  try {
    // 1. Sign in as the nurse
    console.log(`Attempting to sign in as ${nurseEmail}...`);
    const userCredential = await signInWithEmailAndPassword(auth, nurseEmail, nursePassword);
    const user = userCredential.user;
    console.log(`Signed in successfully. User UID: ${user.uid}`);

    // 2. Get a reference to the callable function
    console.log("Getting reference to 'respondToOffer' function...");
    const respondToOffer = httpsCallable(functions, 'respondToOffer');

    // 3. Call the function
    console.log(`Calling 'respondToOffer' with requestId: ${testRequestId}, response: ${testResponse}`);
    const result = await respondToOffer({ requestId: testRequestId, response: testResponse });

    // 4. Log the result
    console.log("'respondToOffer' function returned:", result.data);

  } catch (error) {
    console.error("An error occurred during the test:");
    if (error.code && error.message) {
      // Handle Functions-specific errors
      console.error(`Code: ${error.code}`);
      console.error(`Message: ${error.message}`);
      console.error(`Details:`, error.details);
    } else {
      // Handle other errors (e.g., Auth errors)
      console.error(error);
    }
  }
}

// Run the test
runTest();
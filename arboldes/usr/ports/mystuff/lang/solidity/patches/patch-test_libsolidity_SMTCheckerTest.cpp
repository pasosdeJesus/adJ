Teach SMTIgnoreOS about OpenBSD so SMT tests can be skipped there, extending the existing macos/windows/linux handling (upstream only tests those three in CI).
--- test/libsolidity/SMTCheckerTest.cpp.orig
+++ test/libsolidity/SMTCheckerTest.cpp
@@ -140,6 +140,9 @@
 #elif __linux__
 		if (os == "linux")
 			m_shouldRun = false;
+#elif defined(__OpenBSD__)
+		if (os == "openbsd")
+			m_shouldRun = false;
 #else
 		// On other operating systems this setting is ignored (as we don't test other operating systems in CI),
 		// but we need to prevent an unused-variable warning.

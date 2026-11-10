Skip on OpenBSD: the expected output was recorded with z3 4.13.3, but the packaged z3 is 4.16.0 and reports a slightly different (still valid) SMT result for this test.
--- test/libsolidity/smtCheckerTests/array_members/push_storage_ref_unsafe_length.sol.orig
+++ test/libsolidity/smtCheckerTests/array_members/push_storage_ref_unsafe_length.sol
@@ -25,7 +25,7 @@
 }
 // ====
 // SMTEngine: all
-// SMTIgnoreOS: macos
+// SMTIgnoreOS: macos,openbsd
 // ----
 // Warning 6368: (238-242): CHC: Out of bounds access happens here.
 // Warning 6368: (238-245): CHC: Out of bounds access happens here.

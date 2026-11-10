Skip on OpenBSD: the expected output was recorded with z3 4.13.3, but the packaged z3 is 4.16.0 and reports a slightly different (still valid) SMT result for this test.
--- test/libsolidity/smtCheckerTests/types/fixed_bytes_access_3.sol.orig
+++ test/libsolidity/smtCheckerTests/types/fixed_bytes_access_3.sol
@@ -30,7 +30,7 @@
 }
 // ====
 // SMTEngine: all
-// SMTIgnoreOS: macos
+// SMTIgnoreOS: macos,openbsd
 // ----
 // Warning 6368: (456-462): CHC: Out of bounds access happens here.
 // Info 1391: CHC: 13 verification condition(s) proved safe! Enable the model checker option "show proved safe" to see all of them.

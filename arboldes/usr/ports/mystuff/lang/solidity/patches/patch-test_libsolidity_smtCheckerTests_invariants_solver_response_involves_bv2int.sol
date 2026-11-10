Skip on OpenBSD: the expected output was recorded with z3 4.13.3, but the packaged z3 is 4.16.0 and reports a slightly different (still valid) SMT result for this test.
--- test/libsolidity/smtCheckerTests/invariants/solver_response_involves_bv2int.sol.orig
+++ test/libsolidity/smtCheckerTests/invariants/solver_response_involves_bv2int.sol
@@ -12,5 +12,6 @@
 // SMTEngine: chc
 // SMTIgnoreInv: no
 // SMTSolvers: z3
+// SMTIgnoreOS: openbsd
 // ----
 // Info 1391: CHC: 2 verification condition(s) proved safe! Enable the model checker option "show proved safe" to see all of them.

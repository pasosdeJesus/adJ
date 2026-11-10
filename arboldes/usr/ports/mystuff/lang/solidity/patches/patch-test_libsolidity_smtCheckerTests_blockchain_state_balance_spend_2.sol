Skip on OpenBSD: the expected output was recorded with z3 4.13.3, but the packaged z3 is 4.16.0 and reports a slightly different (still valid) SMT result for this test.
--- test/libsolidity/smtCheckerTests/blockchain_state/balance_spend_2.sol.orig
+++ test/libsolidity/smtCheckerTests/blockchain_state/balance_spend_2.sol
@@ -15,7 +15,7 @@
 // ====
 // SMTEngine: all
 // SMTIgnoreCex: yes
-// SMTIgnoreOS: macos
+// SMTIgnoreOS: macos,openbsd
 // ----
 // Warning 9207: (141-152): 'transfer' is deprecated and scheduled for removal. Use 'call{value: <amount>}("")' instead.
 // Warning 8656: (141-156): CHC: Insufficient funds happens here.

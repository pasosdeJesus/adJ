
6.0
===

* Fallando compilacion de chromium con y sin llave de pdJ:
[1/8] RULE Generating C++ and Python code from policy/proto/policy_signing_key.proto
FAILED: pyproto/policy/proto/policy_signing_key_pb2.py gen/protoc_out/policy/proto/policy_signing_key.pb.cc gen/protoc_out/policy/proto/policy_signing_key.pb.h
cd ../../components; python ../tools/protoc_wrapper/protoc_wrapper.py --include components/policy/policy_proto_export.h --protobuf "../out/Release/gen/protoc_ou
t/policy/proto/policy_signing_key.pb.h" --proto-in-dir policy/proto --proto-in-file "policy_signing_key.proto" "--use-system-protobuf=0" -- ../out/Release/proto
c --cpp_out "dllexport_decl=POLICY_PROTO_EXPORT:../out/Release/gen/protoc_out/policy/proto" --python_out ../out/Release/pyproto/policy/proto
Traceback (most recent call last):
  File "../tools/protoc_wrapper/protoc_wrapper.py", line 134, in <module>
    sys.exit(main(sys.argv))
  File "../tools/protoc_wrapper/protoc_wrapper.py", line 119, in main
    ret = subprocess.call(protoc_args)
  File "/usr/local/lib/python2.7/subprocess.py", line 523, in call
    return Popen(*popenargs, **kwargs).wait()
  File "/usr/local/lib/python2.7/subprocess.py", line 711, in __init__
    errread, errwrite)
  File "/usr/local/lib/python2.7/subprocess.py", line 1343, in _execute_child
    raise child_exception
OSError: [Errno 8] Exec format error



OJO
['../out/Release/protoc', '--cpp_out', 'dllexport_decl=POLICY_PROTO_EXPORT:../out/Release/gen/protoc_out/policy/proto', '--python_out', '../out/Release/pyproto/policy/proto', '--proto_path=policy/proto', 'policy/proto/device_management_backend.proto']



Futuro
======
* En documentacion garantizar que cubrimos lo del FAQ de OpenBSD
* LC_COLLATE con wchar y algoritmo de cotejación Unicode ?
* localedef al menos para cotejación ?
* xiphos debería incluir módulos por defecto.
* Páginas man en español


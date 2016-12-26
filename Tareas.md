
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

Se modifico para gnerar lo que ejecuta:

OJO
['../out/Release/protoc', '--cpp_out', 'dllexport_decl=POLICY_PROTO_EXPORT:../out/Release/gen/protoc_out/policy/proto', '--python_out', '../out/Release/pyproto/policy/proto', '--proto_path=policy/proto', 'policy/proto/device_management_backend.proto']


$ /usr/ports/pobj/chromium-51.0.2704.106/chromium-51.0.2704.106/out/Release/protoc     
/usr/ports/pobj/chromium-51.0.2704.106/chromium-51.0.2704.106/out/Release/protoc[1]: syntax error: `|' unexpected

file /usr/ports/pobj/chromium-51.0.2704.106/chromium-51.0.2704.106/out/Release/protoc
/usr/ports/pobj/chromium-51.0.2704.106/chromium-51.0.2704.106/out/Release/protoc: ELF 64-bit LSB shared object, x86-64, version 1

doas rm /usr/ports/pobj/chromium-51.0.2704.106/chromium-51.0.2704.106/out/Release/protoc

$ doas make
===>  Building for chromium-51.0.2704.106p0
# Build all the resources as the first step to avoid build failures
# due to internal dependency issues.
ninja: Entering directory `out/Release'
ninja: no work to do.
ninja: Entering directory `out/Release'
[1/10] LINK protoc
obj/third_party/protobuf/libprotobuf_full_do_not_use.a(protobuf_full_do_not_use.strutil.o): In function `google::protobuf::CEscapeInternal(char const*, int, char*, int, bool, bool)':
../../third_party/protobuf/src/google/protobuf/stubs/strutil.cc:(.text._ZN6google8protobuf15CEscapeInternalEPKciPcibb+0x177): warning: warning: sprintf() is often misused, please use snprintf()
[2/10] STAMP obj/components/cloud_policy_proto.genproto.stamp
[3/10] RULE Generating C++ and Python code from policy/proto/device_management_backend.proto
FAILED: pyproto/policy/proto/device_management_backend_pb2.py gen/protoc_out/policy/proto/device_management_backend.pb.cc gen/protoc_out/policy/proto/device_management_backend.pb.h
cd ../../components; python ../tools/protoc_wrapper/protoc_wrapper.py --include components/policy/policy_proto_export.h --protobuf "../out/Release/gen/protoc_out/policy/proto/device_management_backend.pb.h" --proto-in-dir policy/proto --proto-in-file "device_management_backend.proto" "--use-system-protobuf=0" -- ../out/Release/protoc --cpp_out "dllexport_decl=POLICY_PROTO_EXPORT:../out/Release/gen/protoc_out/policy/proto" --python_out ../out/Release/pyproto/policy/proto
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
ninja: build stopped: subcommand failed.
*** Error 1 in . (Makefile:188 'do-build': @cd /usr/ports/pobj/chromium-51.0.2704.106/chromium-51.0.2704.106/out/Release &&  for _r in gener...)
*** Error 1 in . (/usr/ports/infrastructure/mk/bsd.port.mk:2670 '/usr/ports/pobj/chromium-51.0.2704.106/.build_done')
*** Error 1 in /usr/ports/www/chromium (/usr/ports/infrastructure/mk/bsd.port.mk:2396 'all')

Futuro
======
* En documentacion garantizar que cubrimos lo del FAQ de OpenBSD
* LC_COLLATE con wchar y algoritmo de cotejación Unicode ?
* localedef al menos para cotejación ?
* xiphos debería incluir módulos por defecto.
* Páginas man en español


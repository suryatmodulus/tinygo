target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64--linux"

declare void @externalCall(i64)

@foo.knownAtRuntime = global i64 0
@bar.knownAtRuntime = global i64 0

define void @runtime.initAll() unnamed_addr {
entry:
  call void @foo.init(i8* undef, i8* undef)
  call void @bar.init(i8* undef, i8* undef)
  call void @main.init(i8* undef, i8* undef)
  ret void
}

define internal void @foo.init(i8* %context, i8* %parentHandle) unnamed_addr {
  store i64 5, i64* @foo.knownAtRuntime
  unreachable ; this triggers a revert of @foo.init.
}

define internal void @bar.init(i8* %context, i8* %parentHandle) unnamed_addr {
  %val = load i64, i64* @foo.knownAtRuntime
  store i64 %val, i64* @bar.knownAtRuntime
  ret void
}

define internal void @main.init(i8* %context, i8* %parentHandle) unnamed_addr {
entry:
  call void @externalCall(i64 3)
  ret void
}
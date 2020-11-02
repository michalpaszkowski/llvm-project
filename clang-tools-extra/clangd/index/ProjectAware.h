//===--- ProjectAware.h ------------------------------------------*- C++-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_TOOLS_EXTRA_CLANGD_INDEX_PROJECT_AWARE_H
#define LLVM_CLANG_TOOLS_EXTRA_CLANGD_INDEX_PROJECT_AWARE_H

#include "Config.h"
#include "index/Index.h"
#include "support/Threading.h"
#include <functional>
#include <memory>
namespace clang {
namespace clangd {

/// A functor to create an index for an external index specification. Functor
/// should perform any high latency operation in a separate thread through
/// AsyncTaskRunner.
using IndexFactory = std::function<std::unique_ptr<SymbolIndex>(
    const Config::ExternalIndexSpec &, AsyncTaskRunner &)>;

/// Returns an index that answers queries using external indices. IndexGenerator
/// can be used to customize how to generate an index from an external source.
/// The default implementation loads the index asynchronously on the
/// AsyncTaskRunner. The index will appear empty until loaded.
std::unique_ptr<SymbolIndex> createProjectAwareIndex(IndexFactory = nullptr);
} // namespace clangd
} // namespace clang

#endif

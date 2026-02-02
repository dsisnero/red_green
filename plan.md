# Red/Green Tree Porting Plan

## Overview

This document outlines the plan for porting the Roslyn red/green tree architecture to Crystal. The red/green tree pattern is a performance-optimized syntax tree design used by the Roslyn compiler platform, separating immutable, position-less "green" nodes from position-aware "red" node wrappers.

## 1. Analysis of Roslyn Red/Green Tree Architecture

### 1.1 Core Concepts

**Green Nodes** (`GreenNode`):

*   Immutable, position-less syntax nodes
*   Cached and reused across syntax trees
*   Contain: kind, flags, slot count, full width
*   Store diagnostics and annotations in weak tables
*   Language-agnostic base, extended per language

**Red Nodes** (`SyntaxNode`):

*   Position-aware wrappers around green nodes
*   Contain: parent reference, absolute position, syntax tree
*   Lazily constructed via `GetRed()` pattern
*   Thread-safe with `Interlocked.CompareExchange`

**Key Data Structures**:

*   `SyntaxToken` - Wraps token green nodes
*   `SyntaxTrivia` - Wraps trivia green nodes
*   `SyntaxList<T>` - Typed list of syntax nodes
*   `SeparatedSyntaxList<T>` - List with separators
*   `SyntaxNodeOrToken` - Union type for nodes/tokens

### 1.2 File Structure Analysis

The Roslyn implementation consists of **82 files** in `/roslyn/src/Compilers/Core/Portable/Syntax/` and **20 files** in `/roslyn/src/Compilers/Core/Portable/Syntax/InternalSyntax/`.

**Critical Files**:

1.  `GreenNode.cs` (1,060 lines) - Green node base class
2.  `SyntaxNode.cs` (1,662 lines) - Red node base class
3.  `SyntaxToken.cs` (705 lines) - Token wrapper struct
4.  `SyntaxTrivia.cs` (452 lines) - Trivia wrapper struct
5.  `SyntaxList.cs` family - List implementations
6.  `SyntaxNodeCache.cs` - Caching system

### 1.3 Performance Optimizations

1.  **Bit Packing**: `NodeFlagsAndSlotCount` packs 12 bits of flags + 4 bits of slot count
2.  **Lazy Red Nodes**: Red nodes created on-demand only
3.  **Specialized Lists**: Different list types for 1, 2, 3, 4-9, 10+ children
4.  **Caching**: Green nodes cached based on hash of kind + children
5.  **Position Caching**: Child positions cached for O(1) access

## 2. Crystal Language Considerations

### 2.1 Language Features

**Available**:

*   Classes and structs (reference vs value types)
*   Immutability via `readonly` properties
*   Generics (with some limitations)
*   Metaprogramming via macros
*   Pattern matching (Crystal 1.0+)

**Challenges**:

*   No `ConditionalWeakTable` equivalent
*   Different concurrency model (fibers vs threads)
*   No `Interlocked.CompareExchange` in standard library
*   Memory management differences

### 2.2 Design Decisions

1.  **Immutable Classes**: Use Crystal classes with readonly properties
2.  **Structs for Wrappers**: `SyntaxToken` and `SyntaxTrivia` as structs
3.  **Caching Strategy**: Prefer a weak-reference cache; fall back to size-bounded strong cache if needed
4.  **Concurrency**: Assume single-threaded initially; add synchronization around shared caches if needed
5.  **Generics**: Use Crystal's generics with type restrictions

## 3. Porting Strategy

### 3.1 Phase 1: Core Infrastructure (Weeks 1-2)

**Goal**: Implement green/red node base classes and basic structure.

**Tasks**:

1.  Create `RedGreen::GreenNode` abstract class
2.  Create `RedGreen::SyntaxNode` abstract class
3.  Implement `NodeFlags` enum and bit packing
4.  Create `SyntaxToken` and `SyntaxTrivia` structs
5.  Implement basic position tracking (including `GetChildPosition` caching)
6.  Define `SyntaxTree` shell type for root/diagnostics ownership

**Files**:

*   `src/red_green/green_node.cr`
*   `src/red_green/syntax_node.cr`
*   `src/red_green/syntax_token.cr`
*   `src/red_green/syntax_trivia.cr`
*   `src/red_green/syntax_tree.cr`

### 3.2 Phase 2: List Infrastructure (Weeks 3-4)

**Goal**: Implement list types and caching system.

**Tasks**:

1.  Create `SyntaxList` base class
2.  Implement specialized lists: `WithTwoChildren`, `WithThreeChildren`, `WithManyChildren`, `WithLotsOfChildren`
3.  Create `SyntaxList<T>` generic wrapper
4.  Implement `SeparatedSyntaxList<T>`
5.  Create caching system (`SyntaxNodeCache`) with strategy toggles

**Files**:

*   `src/red_green/internal_syntax/syntax_list.cr`
*   `src/red_green/syntax_list.cr`
*   `src/red_green/separated_syntax_list.cr`
*   `src/red_green/syntax_node_cache.cr`

### 3.3 Phase 3: Navigation and Utilities (Weeks 5-6)

**Goal**: Implement navigation, iteration, and utility types.

**Tasks**:

1.  Create `ChildSyntaxList` for child enumeration
2.  Implement `SyntaxNodeOrToken` union type
3.  Create `SyntaxTokenList` and `SyntaxTriviaList`
4.  Implement `SyntaxWalker` visitor pattern
5.  Add `SyntaxDiffer` for tree comparison
6.  Add `SyntaxFactory` entry points for tree construction

**Files**:

*   `src/red_green/child_syntax_list.cr`
*   `src/red_green/syntax_node_or_token.cr`
*   `src/red_green/syntax_walker.cr`
*   `src/red_green/syntax_differ.cr`
*   `src/red_green/syntax_factory.cr`

### 3.4 Phase 4: Advanced Features (Weeks 7-8)

**Goal**: Implement annotations, diagnostics, and advanced features.

**Tasks**:

1.  Implement `SyntaxAnnotation` system
2.  Create diagnostic storage (green-side + red-side accessors)
3.  Add structured trivia support
4.  Implement directive handling
5.  Add skipped text support

**Files**:

*   `src/red_green/syntax_annotation.cr`
*   `src/red_green/diagnostics.cr`
*   `src/red_green/structured_trivia.cr`

### 3.5 Phase 5: Testing and Optimization (Weeks 9-10)

**Goal**: Comprehensive testing and performance optimization.

**Tasks**:

1.  Write unit tests for all components
2.  Create benchmark suite
3.  Optimize memory usage
4.  Profile and tune performance
5.  Document public API

**Files**:

*   `spec/` test files
*   `benchmarks/` performance tests
*   `docs/` documentation

## 4. Detailed Design Decisions

### 4.1 Green Node Implementation

```crystal
abstract class RedGreen::GreenNode
  # Packed fields: kind (UInt16), flags_and_slot_count (UInt16), full_width (Int32)
  @kind : UInt16
  @flags_and_slot_count : UInt16
  @full_width : Int32

  # Virtual properties
  abstract def language : String
  abstract def kind_text : String
  abstract def is_token? : Bool
  abstract def is_trivia? : Bool

  # Child access
  abstract def slot_count : Int32
  abstract def get_slot(index : Int32) : GreenNode?
  abstract def create_red(parent : SyntaxNode?, position : Int32) : SyntaxNode
end
```

### 4.2 Red Node Implementation

```crystal
abstract class RedGreen::SyntaxNode
  @parent : SyntaxNode?
  @syntax_tree : SyntaxTree?
  @position : Int32
  @green : GreenNode

  # Lazy child creation
  protected def get_red(field : Reference(T?), slot : Int32) : T? forall T
    result = field
    if result.nil?
      green_child = @green.get_slot(slot)
      if green_child
        field = green_child.create_red(self, get_child_position(slot))
        result = field
      end
    end
    result
  end
end
```

### 4.3 Caching Strategy

**Challenge**: Crystal lacks `ConditionalWeakTable`.

**Solution**: Use a weak-reference map where possible, and optionally fall back to a size-bounded strong cache:

```crystal
class RedGreen::SyntaxNodeCache
  @@cache = Hash(UInt64, WeakRef(GreenNode)).new

  def self.try_get_node(kind : UInt16, children : Array(GreenNode)) : GreenNode?
    hash = compute_hash(kind, children)
    if ref = @@cache[hash]?
      node = ref.value
      return node if node && node.matches?(kind, children)
    end
    nil
  end
end
```

### 4.4 Concurrency Handling

**Initial Approach**: Assume single-threaded usage.

**Future Enhancement**: Add `Mutex` protection for shared caches.

```crystal
class RedGreen::ThreadSafeCache
  @@mutex = Mutex.new
  @@cache = Hash(UInt64, GreenNode).new

  def self.get_or_add(key : UInt64, &block : -> GreenNode) : GreenNode
    @@mutex.synchronize do
      if node = @@cache[key]?
        node
      else
        node = yield
        @@cache[key] = node
        node
      end
    end
  end
end
```

## 5. Testing Plan

### 5.1 Unit Tests

**Coverage Goals**:

*   Green node creation and caching
*   Red node lazy construction
*   Position computation accuracy
*   List operations and enumeration
*   Visitor pattern traversal

**Test Framework**: Crystal's built-in `spec`.

### 5.2 Integration Tests

**Test Scenarios**:

*   Building simple syntax trees
*   Modifying trees (creating new versions)
*   Annotations and diagnostics
*   Tree navigation and searching
*   Serialization/deserialization

### 5.3 Performance Tests

**Benchmarks**:

*   Memory usage per node type
*   Tree construction time
*   Navigation performance
*   Cache hit rates
*   Comparison with Roslyn baseline

## 6. Timeline and Deliverables

### Week 1-2: Core Infrastructure

*   Green/Red node base classes
*   Token and trivia wrappers
*   Basic position tracking

### Week 3-4: List Infrastructure

*   Specialized list implementations
*   Caching system
*   Generic list wrappers

### Week 5-6: Navigation

*   Child enumeration
*   Union types
*   Visitor pattern

### Week 7-8: Advanced Features

*   Annotations and diagnostics
*   Structured trivia
*   Tree differ

### Week 9-10: Testing & Optimization

*   Comprehensive test suite
*   Performance tuning
*   Documentation

## 7. Risks and Mitigation

### 7.1 Technical Risks

**Risk**: Crystal's memory model differs from .NET
**Mitigation**: Start with simple reference types, profile early

**Risk**: Lack of weak reference table
**Mitigation**: Implement custom weak reference cache

**Risk**: Performance not matching Roslyn
**Mitigation**: Focus on algorithmic optimizations, accept Crystal's limits

### 7.2 Project Risks

**Risk**: Scope creep
**Mitigation**: Stick to core red/green tree, defer language-specific features

**Risk**: Insufficient testing
**Mitigation**: Write tests alongside implementation, aim for 80%+ coverage

**Risk**: Documentation gaps
**Mitigation**: Document public API as we go, use Crystal docs format

## 8. Success Criteria

### Primary Goals

1.  Correct implementation of red/green tree pattern
2.  Functional equivalence to Roslyn core API
3.  Reasonable performance for syntax tree operations
4.  Clean, idiomatic Crystal code

### Secondary Goals

1.  Comprehensive test coverage
2.  Good documentation
3.  Extensible architecture
4.  Potential for language-specific extensions

## 9. Next Steps

1.  **Immediate**: Review this plan and provide feedback
2.  **Setup**: Initialize Crystal project structure
3.  **Implementation**: Begin Phase 1 (Green/Red node base classes)
4.  **Iterate**: Weekly review of progress and adjustments

---

*Last Updated: February 2, 2026*
*Version: 1.0*

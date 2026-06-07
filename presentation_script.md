# ZX Calculus in Haskell — Presentation Script
**Two speakers: A and B**
*~15–20 minutes total*

---

## Slide 1 — Title

**A:** Good morning everyone. Today we're presenting our work on ZX Calculus in Haskell.

 The core idea is to start from very simple classical Boolean maps — things like swap, copy, and XOR — and then lift the whole structure into the quantum world using what's called the free Hilbert space functor. We implement and test everything directly in Haskell.

---

## Slide 2 — Classical Maps: Bits & Core Functions

**B:** Let's start on the classical side. We model computation over bits, which in Haskell are just Booleans. We define five primitive maps that generate everything we need.

**B:** Swap takes a pair of bits and exchanges them. Delete discards a bit and returns unit. Copy duplicates a bit into a pair. Falsum ignores its input and always returns False. And XOR is the standard exclusive-or on two bits. These five maps are the building blocks — every rule we test will be an equation between compositions of these.

---

## Slide 3 — Haskell Implementation

**A:** Here's the actual code. The implementations are completely straightforward. Swap pattern-matches the pair and flips it. Copy returns the same bit twice. Falsum ignores unit and returns False. XOR is defined by all four cases explicitly.


---

## Slide 4 — Rule 1: XOR is commutative

**A:** Now we test three classical rules. The first is that XOR is commutative: XOR of a and b equals XOR after swapping the inputs. In Haskell, `testSwapXor` checks this for a given pair, and it holds for all four input combinations.

---

## Slide 5 — Rule 2: Copy-XOR law

**B:** The second rule is the copy-XOR law. If you copy a bit and then apply XOR to the two copies, you get the same result as deleting the bit and returning False through `falsum`. The intuition is simple: XOR of a bit with itself is always False. The function `testCopyXor` verifies this for both True and False.

---

## Slide 6 — Rule 3: Bialgebra law

**A:** The third rule is the most interesting one — the bialgebra law. It says that copying first and then XOR-ing each copy in parallel gives the same result as XOR-ing first and then copying. There's a swap in the middle to untangle the wires correctly.

**B:** In code, we compute the left side by copying the result of XOR, and the right side by copying both inputs, swapping the inner pair, and then applying XOR to each resulting pair. `testBialgebra` checks that both sides are equal for any input pair — and they are.

---

## Slide 7 — The Category of Complex Matrices

**A:** Now we move to the quantum side. In the quantum world, we replace sets by natural numbers — objects are just dimensions — and morphisms are complex matrices. The key function here is `toMatrix`. Given an input list, an output list, and a function between them, it builds a matrix where entry row-i, column-j is one if the function maps input j to output i, and zero otherwise.

**B:** This is exactly how the free Hilbert space functor acts on morphisms — it turns a function into its matrix representation. We use this to produce matrices for all five of our classical maps: `notM`, `copyM`, `swapM`, `xorM`, `falsumM`, and `deleteM`.

---

## Slide 8 — matMul & tensor

**A:** We also need two operations on matrices. `matMul` is standard matrix multiplication, which corresponds to sequential composition — doing one thing after another. `tensor` is the tensor product, which corresponds to parallel composition — running two systems side by side.

**B:** Together with the `identity` matrix as the unit, these three operations give us everything we need to express the same algebraic rules as before, but now as equations between matrices.

---

## Slide 9 — Three Quantum Rules Verified

**A:** We now verify the same three rules at the matrix level. Rule 1: `xorM` equals `xorM` composed with `swapM` — commutativity still holds. Rule 2: `xorM` composed with `copyM` equals `falsumM` composed with `deleteM` — the copy-XOR law holds as a matrix identity.

**B:** And rule 3, the bialgebra law: the tensor of `xorM` with itself, composed with the identity-swap-identity interchanger in the middle, composed with the tensor of `copyM` with `copyM` — all of that equals `copyM` composed with `xorM`. All three functions evaluate to `True` in Haskell.

---

## Slide 10 — Thank You

**A:** That's all from us — thank you for listening.

**B:** We're happy to take any questions.

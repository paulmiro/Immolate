// you can use this file to find the probabilities of finding certain seeds
// The current version calculates the approximate probability of finding a 9-discard seed with the zero_hand_run filter

const chances = {
  jokers: {
    common: 0.7 / 61, // 1 in ~87
    uncommon: 0.25 / 64, // 1 in 256
    rare: 0.05 / 20, // 1 in 400
  },
  tarot: 1 / 22,
  two_tarots_from_mega_pack: 0.04329004329, // calculated with hypergemoetric distribution
  one_tarot_from_mega_pack: 0.22727272727272727,
  tags: {
    firstAnte: 1 / 15,
    otherAntes: 1 / 24,
  },
  boss: (ante: number) => {
    if (ante <= 1) return 1 / 8
    if (ante <= 2) return 1 / 18
    if (ante <= 3) return 1 / 20
    if (ante <= 5) return 1 / 21
    if (ante % 8 == 0) return 1 / 5
    return 1 / 22
  }
}
const factorial = (n: number) => !n ? 1 : n * factorial(--n);



let prob = 1

// first tag is double or charm
prob *= chances.tags.firstAnte // * 2 // if you want to be optimistic about finding showman in the first pack
// second tag is charm
prob *= chances.tags.firstAnte

// --- Judgement Queue ---
// draw a Showman
prob *= chances.jokers.uncommon
// draw two Merry Andys
prob *= chances.jokers.uncommon
prob *= chances.jokers.uncommon
// there are 4! = 24 possible permutations for this to happen
prob *= factorial(4)

// tarot cards
prob *= chances.two_tarots_from_mega_pack
prob *= chances.two_tarots_from_mega_pack

let seeds = 2318107019760 // number of possible seeds
/* calculated with 
let seeds = 0
for (let i = 1; i <= 8; i++) {
  seeds += 35 ** i
}
*/

console.log(
  prob * seeds > 1
    ? "expected amount of seeds to exist: " + (prob * seeds).toFixed(2)
    : "probability that a seed exists: " + (prob * seeds * 100).toFixed(2) + "%"
)

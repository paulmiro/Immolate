let chances = {
  jokers: {
    common: 0.7 / 61,
    uncommon: 0.25 / 64,
    rare: 0.05 / 20,
  },
  tarot: 1 / 22,
  two_tarots_from_mega_pack: 0.04329004329, // calculated with hypergemoetric distribution
  tags: {
    firstAnte: 1 / 15,
    otherAntes: 1 / 24,
  },
}

let prob = 1

// first tag is double or charm
prob *= chances.tags.firstAnte
// second tag is charm
prob *= chances.tags.firstAnte

// --- Judgement Queue ---
// draw a Stuntman
prob *= chances.jokers.rare
// draw a Blueprint
prob *= chances.jokers.rare
// draw a Brainstorm
prob *= chances.jokers.rare
// draw a Merry Andy
prob *= chances.jokers.uncommon
// there are 4! = 24 possible permutations
prob *= 24

// tarot cards
for (let i = 0; i < 2; i++) {
  prob *= chances.two_tarots_from_mega_pack
}

console.log("probability per seed is " + prob)

let seeds = 2318107019760 // number of possible seeds

/* calculated with 
let seeds = 0
for (let i = 1; i <= 8; i++) {
  seeds += 35 ** i
}
*/

console.log("expected amount of seeds that exist " + prob * seeds)

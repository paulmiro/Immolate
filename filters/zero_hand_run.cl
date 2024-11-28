// Lose a run without ever playing a single hand.
// This works by getting at leas 8 discards on abandoned deck
// and then discarding all cards on the boss blind.

#include "lib/immolate.cl"

long filter(instance *inst) {
  int ante = 1;

  bool needsShowmanOnFirstPack = false;
  int numMerry = 0;
  int numDrunk = 0;
  bool hasShowman = false;

  item firstTag = next_tag(inst, ante);
  if (firstTag == Double_Tag) {
    // When using a double tag to create the second pack it opens
    // immediately after the using the fool from the first pack.
    // without showman, this would make it impossible to find a
    // judgement in the second pack
    needsShowmanOnFirstPack = true;
  } else if (firstTag != Charm_Tag) {
    // no good first tag
    return 0l;
  }

  item secondTag = next_tag(inst, ante);

  if (secondTag != Charm_Tag) {
    // no good second tag
    return 0l;
  }

  // First Pack has to include exactly one Judgement and one Fool
  item arcanaPack1[5];
  arcana_pack(arcanaPack1, 5, inst, ante);
  bool foundJudgement = false;
  bool foundFool = false;
  for (int i = 0; i < 5; i++) {
    if (arcanaPack1[i] == Judgement) {
      foundJudgement = true;
    }
    if (arcanaPack1[i] == The_Fool) {
      foundFool = true;
    }
  }
  if (!foundJudgement || !foundFool) {
    return 0l;
  }

  for (int i = 0; i < 2; i++) {
    item jkr = next_joker(inst, S_Judgement, ante);
    if (jkr == Merry_Andy) {
      numMerry++;
      inst->locked[Merry_Andy] = true;
    }
    if (jkr == Drunkard) {
      numDrunk++;
      inst->locked[Drunkard] = true;
    }
    if (jkr == Showman) {
      inst->params.showman = true;
      hasShowman = true;
    }
  }
  if (!hasShowman && needsShowmanOnFirstPack) {
    // second pack cannot have a judgement in this case
    return 0l;
  }

  // slightly different checking here because we have already used
  // a judgement as our last arcana and we may or may not have
  // showman at this point
  int numJudgements = 0;
  item arcanaPack2[5];
  arcana_pack(arcanaPack2, 5, inst, ante);
  for (int i = 0; i < 5; i++) {
    if (arcanaPack2[i] == Judgement) {
      numJudgements++;
    }
    if (arcanaPack2[i] == The_Fool) {
      numJudgements++;
    }
  }
  if (numJudgements == 0) {
    return 0l;
  }
  if (numJudgements > 2) {
    // we can only use 2 of them
    numJudgements = 2;
  }

  for (int i = 0; i < numJudgements; i++) {
    item jkr = next_joker(inst, S_Judgement, ante);
    if (jkr == Merry_Andy) {
      numMerry++;
      inst->locked[Merry_Andy] = true;
    }
    if (jkr == Drunkard) {
      numDrunk++;
      inst->locked[Drunkard] = true;
    }
    if (jkr == Showman) {
      inst->params.showman = true;
      hasShowman = true;
    }
  }

  long discards = numMerry * 3 + numDrunk + 3;

  return discards;
}
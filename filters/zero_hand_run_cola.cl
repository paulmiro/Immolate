// Lose a run without ever playing a single hand.
// This works by getting at leas 8 discards on abandoned deck and then
// discarding all cards on the boss blind.

#include "lib/immolate.cl"

bool has_two_charm_tags(instance *inst, int ante) {
  // order of operations here is intentional to avoid the second check if
  // the first one fails
  item firstTag = next_tag(inst, ante);
  if (firstTag != Charm_Tag) {
    return false;
  }
  item secondTag = next_tag(inst, ante);
  if (secondTag != Charm_Tag) {
    return false;
  }
  return true;
}

long filter(instance *inst) {
  int ante = 1;

  if (!has_two_charm_tags(inst, ante)) {
    return 1;
  }

  int colaIndex = 999;
  // check for jokers first, for performance reasons
  for (int i = 0; i < 3; i++) {
    item jkr = next_joker(inst, S_Judgement, ante);
    if (jkr == Diet_Cola) {
      colaIndex = i;
    } else if (!(jkr == Drunkard || jkr == Merry_Andy)) {
      return 2;
    }
  }
  if (colaIndex >= 2) {
    return 3;
    // cola needs to be one of the first two jokers
    // (and sometimes the first one, see below)
  }

  bool drunkard = false;
  bool merryAndy = false;
  bool cola = false;

  int numJudgements = 0;
  int numFools = 0;
  int numHangedMans = 0;

  int pickable = 0;
  for (int pack = 0; pack < 3; pack++) {
    pickable += 2;
    bool judgement = false;
    bool fool = false;
    bool hangedMan = false;

    item arcanaPack[5];
    arcana_pack(arcanaPack, 5, inst, ante);
    for (int arcana = 0; arcana < 5; arcana++) { // enumerate useful tarots
      if (arcanaPack[arcana] == Judgement) {
        judgement = true;
      } else if (arcanaPack[arcana] == The_Fool) {
        fool = true;
      } else if (arcanaPack[arcana] == The_Hanged_Man) {
        hangedMan = true;
      }
    }
    if (pack == 0) {
      if (!judgement) {
        return 4;
        // no judgement = no cola
      }
      if (!fool && colaIndex >= 1) {
        return 5;
        // no fool = no cola if cola is the second joker in the queue
      }
    }
    int usefulTarots = 0;
    if (judgement)
      usefulTarots++;
    if (fool)
      usefulTarots++;
    if (hangedMan)
      usefulTarots++;
    if (usefulTarots < 2) {
      return 6;
      // pack does not contain enough useful tarots
    }

    // TODO: this will overcount sometimes, but i'll leave it like this for now
    // to make sure we dont waste okayish seeds
    if (judgement)
      numJudgements++;
    if (fool)
      numFools++;
    if (hangedMan)
      numHangedMans++;
  }

  // choose what to do with fools
  while (numFools > 0) {
    if (numJudgements < 3) {
      numJudgements++;
    } else {
      numHangedMans++;
    }
    numFools--;
  }
  if (numJudgements < 3) {
    return 7;
    // not enough judgements to get all jokers
  }
  if (numHangedMans < 3) {
    return 8;
    // not enough hanged men to get all jokers
  }
  return 999;
}

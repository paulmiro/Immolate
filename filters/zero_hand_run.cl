// Lose a run without ever playing a single hand.
// This works by getting at leas 8 discards on abandoned deck and then
// discarding all cards on the boss blind.

#include "lib/immolate.cl"

long filter(instance *inst) {
  int ante = 1;
  long discards = 3;

  item firstTag = next_tag(inst, ante);
  item secondTag = next_tag(inst, ante);

  if ((firstTag != Charm_Tag && firstTag != Double_Tag) ||
      secondTag != Charm_Tag) {
    return 0; // we always want two charm tags
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
    return 0;
  }

  bool foundShowman = false;
  for (int i = 0; i < 2; i++) {
    item jkr = next_joker(inst, S_Judgement, ante);
    if (jkr == Merry_Andy) {
      discards += 3;
    }
    if (jkr == Drunkard) {
      discards += 1;
    }
    if (jkr == Showman) {
      inst->params.showman = true;
      foundShowman = true;
    }
  }
  if (!foundShowman) {
    return 0;
  }

  // Pack 2 can now include any amount of judgements / fools, but we need at
  // least 2
  item arcanaPack2[5];
  arcana_pack(arcanaPack1, 5, inst, ante);
  int judgements = 0;
  for (int i = 0; i < 5; i++) {
    if (arcanaPack1[i] == Judgement) {
      judgements++;
    }
    if (arcanaPack1[i] == The_Fool) {
      judgements++;
    }
  }
  if (judgements < 2) {
    return 0;
  }
  return 1;

  for (int i = 0; i < 2; i++) {
    item jkr = next_joker(inst, S_Judgement, ante);
    if (jkr == Merry_Andy) {
      discards += 3;
    }
    if (jkr == Drunkard) {
      discards += 1;
    }
  }

  return discards;
}
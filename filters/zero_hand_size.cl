// Lose a run without ever playing a single hand.
// This works by getting at leas 8 discards on abandoned deck and then
// discarding all cards on the boss blind.

#include "lib/immolate.cl"

long filter(instance *inst) {
  int ante = 1;

  long hand_size_removed = 0;

  item firstTag = next_tag(inst, ante);
  item secondTag = next_tag(inst, ante);

  if (firstTag != Charm_Tag || secondTag != Charm_Tag) {
    return 0;
    // we always want two charm tags
  }

  item boss = next_boss(inst, ante);
  if (boss != The_Plant) {
    return 0;
  }

  hand_size_removed += 1;

  // First Pack has to include exactly one Judgement and one Fool
  item arcanaPack1[5];
  arcana_pack(arcanaPack1, 5, inst, ante);
  bool foundJudgement1 = false;
  bool foundFool1 = false;
  for (int i = 0; i < 5; i++) {
    if (arcanaPack1[i] == Judgement) {
      foundJudgement1 = true;
    }
    if (arcanaPack1[i] == The_Fool) {
      foundFool1 = true;
    }
  }
  if (!foundJudgement1 || !foundFool1) {
    return 0;
  }

  // First Pack has to include exactly one Judgement and one Fool
  item arcanaPack2[5];
  arcana_pack(arcanaPack2, 5, inst, ante);
  bool foundJudgement2 = false;
  bool foundFool2 = false;
  for (int i = 0; i < 5; i++) {
    if (arcanaPack2[i] == Judgement) {
      foundJudgement2 = true;
    }
    if (arcanaPack2[i] == The_Fool) {
      foundFool2 = true;
    }
  }
  if (!foundJudgement2 || !foundFool2) {
    return 0;
  }

  bool stunt = false;
  bool merry = false;
  bool blue = false;
  bool brain = false;
  for (int i = 0; i < 4; i++) {
    item jkr = next_joker(inst, S_Judgement, ante);
    if (jkr == Blueprint) {
      blue = true;
    }
    if (jkr == Brainstorm) {
      brain = true;
    }
    if (jkr == Stuntman) {
      stunt = true;
    }
    if (jkr == Merry_Andy) {
      merry = true;
    }
  }

  if (stunt) {
    hand_size_removed += 2;
    if (blue) {
      hand_size_removed += 2;
    }
    if (brain) {
      hand_size_removed += 2;
    }
  } else if (merry) {
    if (blue) {
      hand_size_removed += 1;
    }
    if (brain) {
      hand_size_removed += 1;
    }
  }
  if (merry) {
    hand_size_removed += 1;
  }

  return hand_size_removed;
}
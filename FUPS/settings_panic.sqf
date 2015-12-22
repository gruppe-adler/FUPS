// Should the panic system be enabled overall?
#define FUPS_panic_enabled true

// Value the panic will be risen when a team member is killed
#define FUPS_panic_killed 0.5
// Value the panic will be risen when an enemy shot is fired in the vicinity
#define FUPS_panic_firedNear 0.01
// Value the panic will be risen when a team member is damaged by an explosion (adds up to FUPS_panic_hit)
#define FUPS_panic_explosion 0.05
// Value the panic will be risen when a team member is hit
#define FUPS_panic_hit 0.05

// Value the panic will be lowered per second
#define FUPS_panic_lowerPanicPerSecond 0.0015 // This will cause a kill to be "forgotten" after approximatley 5 minutes

// Threshold of panic level to consider the group being paniced
#define FUPS_panic_isNervousThreshold 0.7
// Threshold of panic level to consider the group being paniced
#define FUPS_panic_isPanickedThreshold 1.5

// Chance a group will skip an action, when it is nervous
#define FUPS_panic_skipAction_nervous 0.5
// Chance a group will skip an action, when it is panicked
#define FUPS_panic_skipAction_panicked 0.8

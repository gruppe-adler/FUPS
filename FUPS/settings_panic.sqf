// Should the panic system be enabled overall?
FUPS_panic_enable = true;

// Value the panic will be risen when a team member is killed
FUPS_panic_killed = 0.5;
// Value the panic will be risen when an enemy shot is fired in the vicinity
FUPS_panic_firedNear = 0.01;
// Value the panic will be risen when a team member is damaged by an explosion (adds up to FUPS_panic_hit)
FUPS_panic_explosion = 0.05;
// Value the panic will be risen when a team member is hit
FUPS_panic_hit = 0.05;

// Value the panic will be lowered per second
FUPS_panic_lowerPanicPerSecond = 0.0015; // This will cause a kill to be "forgotten" after approximatley 5 minutes

// Threshold of panic level to consider the group being paniced
FUPS_panic_isNervousThreshold = 0.7;
// Threshold of panic level to consider the group being paniced
FUPS_panic_isPanickedThreshold = 1.5;

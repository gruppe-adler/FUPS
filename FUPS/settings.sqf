// The standard simulation distance for units having the parameter ["simulation:",-1]
#define FUPS_simulation_dist 3500
// The time a FUPS group will search for a once detected enemy _after_ they lost contact
#define FUPS_timeOnTarget 300
// The distance enemies will be shared between FUPS groups, the distance is apllied to the shared enemy, not to the sharing unit
#define FUPS_shareDist 900
// The percentage of damage a group has to take to most likely retreat. This percentage value will be applied to the whole group, meaning: 1 <-> whol egroup is dead, 0 <-> none of the members is damaged in any way
#define FUPS_damageToRetreat 0.4
// If the group has a knowledge of knowsAbout greater this value, it will consider the enemy to be known
#define FUPS_knowsAboutThreshold 0.5

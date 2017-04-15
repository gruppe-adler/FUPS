import math

def damagePanic(damage):
	return math.exp(math.log(11) * damage) - 1

def suppressionPanic(suppression):
	return 0.0872*(suppression**2)

factorDamage = 1 # 0.8
factorSuppression = 1 # 0.2
declineRate = 0.0035

print ("damage\t\tsuppression\tpanic\t\ttime back to 1")
for damage in range(0, 10):
	for suppression in range(0, 10):
		panic = damagePanic(damage * 0.1) * factorDamage + suppressionPanic(suppression * 0.1) * factorSuppression
		panic = min(panic, 10)
		timeToOne = 0
		if (panic > 1):
			timeToOne = (panic - 1) / declineRate
		print (format(damage * 0.1, ".1f") + "\t\t" + format(suppression * 0.1, ".1f") + "\t\t" + format(panic, ".3f") + "\t\t" + format(timeToOne, ".3f"))


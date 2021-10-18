def plc_global path_synch IndvDanceDemoIfTyp gRoutingDemoIf

DEFINE MoveAbsB AS G90 G101 G126
DEFINE MoveRelB AS G91 G101 G126

G71 (Set the units to mm)
def REAL parFeedRate = gRoutingDemoIf.Par.RobotVelocity * 60
F= parFeedRate
N100 MoveAbsB 0 X=480 Y=60 Z=155 

N10 $WHILE gRoutingDemoIf.Cmd.Run
    
    N101 MoveAbsB 50 X=580 Y=60 Z=175 
    G91 (Relative)
    N250 G02 I=-100 H720 Z=-100
    N250 G02 I=-100 H720 Z=100
    N250 G02 I=-125 H180 Z=-20
    N250 G02 I=150 H180 Z=-20 F= parFeedRate * 1.75
    N250 G02 I=-175 H180 Z=-20
    N250 G02 I=200 H180 Z=-20 F= parFeedRate * 2
    N250 G02 I=-200 H180 Z=20
    N250 G02 I=175 H180 Z=20
    N250 G02 I=-150 H180 Z=20
    N250 G02 I=125 H180 Z=20 F= parFeedRate
    N250 G02 I=-100 H180 Z=10
    N250 G02 I=75 H180 Z=10
    N250 G02 I=-50 H180 Z=-30
    N250 G02 I=25 H540 Z=30
    N250 G02 I=25 H540 Z=-60
    G172
$ENDWHILE

N999 MoveAbsB 0 X=480 Y=60 Z=155 
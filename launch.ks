function main {

    // doLaunch().
    // doAscent().
    
    // until apoapsis > 100 * 1000 {
    //     doAutoStage().
    // }

    // doShutDown().

    executeManeuver(time:seconds + 30, 100, 100, 100).
}

function executeManeuver {
    parameter utime, radial, normal, prograde.
    local mnv is node(utime, radial, normal, prograde).
    addManeuverToFlightPlan(mnv).
    local startTime is calculateStartTime(mnv).
    wait until time:seconds > startTime - 10.
    lockSteeringAtManeuverTarget(mnv).
    wait until time:seconds > startTime.
    lock throttle to 1.
    wait until isManeuverComplete(mnv).
    lock throttle to 0.
    removeManeuverFromFlightPlan(mnv).
}

function addManeuverToFlightPlan {
    parameter mnv.
}

function calculateStartTime {
    parameter mnv.

    return 0.
}

function lockSteeringAtManeuverTarget {
    parameter mnv.
}

function isManeuverComplete {
    parameter mnv.

    return true.
}

function removeManeuverFromFlightPlan {
    parameter mnv.
}

function doSafeStage {
    wait until stage:ready.
    stage.
}

function doLaunch {
    lock throttle to 1.
    doSafeStage().
}

function doAscent {
    lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    set targetDirection to 90.
    lock steering to heading(targetDirection, targetPitch).
}

function doAutoStage {
    if not(defined oldThrust) {
        declare global oldThrust to ship:availableThrust.
    }

    if ship:availableThrust < (oldThrust - 10) {
        doSafeStage(). wait 1.
        set oldThrust to ship:availablethrust.
    }
}

function doShutDown {
    lock throttle to 0.
    lock steering to prograde.

    wait until false.
}

main().

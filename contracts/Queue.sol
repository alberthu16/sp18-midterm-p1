pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
    /* State variables */
    uint8 size = 5;
    // YOUR CODE HERE
    uint maxTimeInFirst = 2 minutes;
    uint8 totalPeopleWaiting = 0;
    uint8 indexOfFirst = 0;
    uint8 indexOfLast = 0;
    uint firstPositionTimestamp = 0;
    mapping(uint8 => address) positionToAddr;
    mapping(address => uint8) addrToPosition;

    /* Add events */
    // YOUR CODE HERE
    event Ejected(address ejectedAddress, uint ejectionTime);

    /* Add constructor */
    // YOUR CODE HERE

    /* Returns the number of people waiting in line */
    function qsize() constant returns(uint8) {
        // YOUR CODE HERE
        return totalPeopleWaiting;
    }

    /* Returns whether the queue is empty or not */
    function empty() constant returns(bool) {
        // YOUR CODE HERE
        return totalPeopleWaiting == 0;
    }
    
    /* Returns the address of the person in the front of the queue */
    function getFirst() constant returns(address) {
        // YOUR CODE HERE
        return positionToAddr[indexOfFirst];
    }
    
    /* Allows `msg.sender` to check their position in the queue */
    function checkPlace() constant returns(uint8) {
        // YOUR CODE HERE
        if (addrToPosition[msg.sender] == 0) {
            return size+1;
        } else {
            return addrToPosition[msg.sender];
        }
    }
    
    /* Allows anyone to expel the first person in line if their time
     * limit is up
     */
    function checkTime() {
        // YOUR CODE HERE
        if (firstPositionTimestamp != 0 && (firstPositionTimestamp + maxTimeInFirst <= now)) {
            dequeue();
        }
    }
    
    /* Removes the first person in line; either when their time is up or when
     * they are done with their purchase
     */
    function dequeue() {
        // YOUR CODE HERE

        address addr = positionToAddr[indexOfFirst];
        if (addr != 0) {
            firstPositionTimestamp = now;
            positionToAddr[indexOfFirst] = 0;
            indexOfFirst = (indexOfFirst + 1) % size;
            totalPeopleWaiting -= 1;

            Ejected(addr, now);
        }
    }

    /* Places `addr` in the first empty position in the queue */
    function enqueue(address addr) {
        // YOUR CODE HERE
        if (totalPeopleWaiting < size) {
            if (totalPeopleWaiting == 0) {
                firstPositionTimestamp = now;
            }
            positionToAddr[indexOfLast] = addr;
            addrToPosition[addr] = indexOfLast;
            indexOfLast = (indexOfLast + 1) % size;
            totalPeopleWaiting += 1;
        }
    }

}

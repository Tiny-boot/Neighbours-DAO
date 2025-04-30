Resolving deltas: 100% (17/17), done.
[⠊] Compiling...
[⠒] Compiling 76 files with Solc 0.8.28
[⠢] Solc 0.8.28 finished in 3.03s
Compiler run successful!
(slither-env) kader@SKY:~/NeighborsDAO$ slither .
'forge clean' running (wd: /home/kader/NeighborsDAO)
'forge config --json' running
'forge build --build-info --skip */test/** */script/** --force' running (wd: /home/kader/NeighborsDAO)
INFO:Detectors:
Governor._executeOperations(uint256,address[],uint256[],bytes[],bytes32) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#460-471) sends eth to arbitrary user
        Dangerous calls:
        - (success,returndata) = targets[i].call{value: values[i]}(calldatas[i]) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#468)
Governor.relay(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#680-683) sends eth to arbitrary user
        Dangerous calls:
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#681)
TimelockController._execute(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#412-415) sends eth to arbitrary user
        Dangerous calls:
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#413)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations
INFO:Detectors:
NeighborRewardToken._startOfYear(uint256) (src/NRT.sol#55-57) uses a weak PRNG: "ts - (ts % 31536000) (src/NRT.sol#56)"
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#weak-PRNG
INFO:Detectors:
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) has bitwise-xor operator ^ instead of the exponentiation operator **:
         - inverse = (3 * denominator) ^ 2 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#257)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-exponentiation
INFO:Detectors:
Governor._name (lib/openzeppelin-contracts/contracts/governance/Governor.sol#48) shadows:
        - EIP712._name (lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#49)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variable-shadowing
INFO:Detectors:
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse = (3 * denominator) ^ 2 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#257)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#261)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#262)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#263)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#264)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#265)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - denominator = denominator / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#242)
        - inverse *= 2 - denominator * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#266)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) performs a multiplication on the result of a division:
        - low = low / twos (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#245)
        - result = low * inverse (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#272)
Math.invMod(uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#315-361) performs a multiplication on the result of a division:
        - quotient = gcd / remainder (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#337)
        - (gcd,remainder) = (remainder,gcd - remainder * quotient) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#339-346)
NeighborRewardToken._rollYear() (src/NRT.sol#47-53) performs a multiplication on the result of a division:
        - yearsPassed = (block.timestamp - yearStart) / 31536000 (src/NRT.sol#49)
        - yearStart += yearsPassed * 31536000 (src/NRT.sol#50)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#divide-before-multiply
INFO:Detectors:
TimelockController.getOperationState(bytes32) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#207-218) uses a dangerous strict equality:
        - timestamp == 0 (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#209)
TimelockController.getOperationState(bytes32) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#207-218) uses a dangerous strict equality:
        - timestamp == _DONE_TIMESTAMP (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#211)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities
INFO:Detectors:
Reentrancy in StreakDistributor.finaliseQuarter(uint256) (src/StreakDistributor.sol#58-71):
        External calls:
        - require(bool,string)(NRT.transferFrom(msg.sender,address(this),poolAmt),transfer failed) (src/StreakDistributor.sol#62)
        State variables written after the call(s):
        - currentQtr += 1 (src/StreakDistributor.sol#69)
        StreakDistributor.currentQtr (src/StreakDistributor.sol#28) can be used in cross function reentrancies:
        - StreakDistributor.addPoint(address) (src/StreakDistributor.sol#48-55)
        - StreakDistributor.currentQtr (src/StreakDistributor.sol#28)
        - StreakDistributor.finaliseQuarter(uint256) (src/StreakDistributor.sol#58-71)
        - q.pool = poolAmt (src/StreakDistributor.sol#64)
        StreakDistributor.quarters (src/StreakDistributor.sol#29) can be used in cross function reentrancies:
        - StreakDistributor.addPoint(address) (src/StreakDistributor.sol#48-55)
        - StreakDistributor.claim(uint256) (src/StreakDistributor.sol#74-88)
        - StreakDistributor.constructor(NeighborRewardToken,address,address) (src/StreakDistributor.sol#37-45)
        - StreakDistributor.finaliseQuarter(uint256) (src/StreakDistributor.sol#58-71)
        - StreakDistributor.quarters (src/StreakDistributor.sol#29)
        - StreakDistributor.sweepRemainder(uint256,address) (src/StreakDistributor.sol#93-104)
        - q.finalised = true (src/StreakDistributor.sol#65)
        StreakDistributor.quarters (src/StreakDistributor.sol#29) can be used in cross function reentrancies:
        - StreakDistributor.addPoint(address) (src/StreakDistributor.sol#48-55)
        - StreakDistributor.claim(uint256) (src/StreakDistributor.sol#74-88)
        - StreakDistributor.constructor(NeighborRewardToken,address,address) (src/StreakDistributor.sol#37-45)
        - StreakDistributor.finaliseQuarter(uint256) (src/StreakDistributor.sol#58-71)
        - StreakDistributor.quarters (src/StreakDistributor.sol#29)
        - StreakDistributor.sweepRemainder(uint256,address) (src/StreakDistributor.sol#93-104)
        - quarters[currentQtr].startTime = block.timestamp (src/StreakDistributor.sol#70)
        StreakDistributor.quarters (src/StreakDistributor.sol#29) can be used in cross function reentrancies:
        - StreakDistributor.addPoint(address) (src/StreakDistributor.sol#48-55)
        - StreakDistributor.claim(uint256) (src/StreakDistributor.sol#74-88)
        - StreakDistributor.constructor(NeighborRewardToken,address,address) (src/StreakDistributor.sol#37-45)
        - StreakDistributor.finaliseQuarter(uint256) (src/StreakDistributor.sol#58-71)
        - StreakDistributor.quarters (src/StreakDistributor.sol#29)
        - StreakDistributor.sweepRemainder(uint256,address) (src/StreakDistributor.sol#93-104)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1
INFO:Detectors:
TimelockController._execute(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#412-415) ignores return value by Address.verifyCallResult(success,returndata) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#414)
SignatureChecker.isValidSignatureNow(address,bytes32,bytes) (lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#22-29) ignores return value by (recovered,err,None) = ECDSA.tryRecover(hash,signature) (lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#24)
Time.get(Time.Delay) (lib/openzeppelin-contracts/contracts/utils/types/Time.sol#93-96) ignores return value by (delay,None,None) = self.getFull() (lib/openzeppelin-contracts/contracts/utils/types/Time.sol#94)
Votes._push(Checkpoints.Trace208,function(uint208,uint208) returns(uint208),uint208) (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#232-238) ignores return value by store.push(clock(),op(store.latest(),delta)) (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#237)
Governor._executeOperations(uint256,address[],uint256[],bytes[],bytes32) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#460-471) ignores return value by Address.verifyCallResult(success,returndata) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#469)
Governor.relay(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#680-683) ignores return value by Address.verifyCallResult(success,returndata) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#682)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return
INFO:Detectors:
ERC20Permit.constructor(string).name (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#39) shadows:
        - ERC20.name() (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#52-54) (function)
        - IERC20Metadata.name() (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#15) (function)
NeighborGovernor.constructor(ERC20Votes,TimelockController,StreakDistributor).token (src/NeighborGovernor.sol#28) shadows:
        - GovernorVotes.token() (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#26-28) (function)
NeighborGovernor.constructor(ERC20Votes,TimelockController,StreakDistributor).timelock (src/NeighborGovernor.sol#28) shadows:
        - GovernorTimelockControl.timelock() (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#66-68) (function)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#local-variable-shadowing
INFO:Detectors:
NeighborGovToken.constructor(uint256,uint256,address).cityRegistrar (src/NGT.sol#29) lacks a zero-check on :
                - REGISTRAR = cityRegistrar (src/NGT.sol#35)
Governor.relay(address,uint256,bytes).target (lib/openzeppelin-contracts/contracts/governance/Governor.sol#680) lacks a zero-check on :
                - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#681)
RepresentativeCouncil.signAndForward(address,RepresentativeCouncil.Impact,bytes).governor (src/RepresentativeCouncil.sol#49) lacks a zero-check on :
                - (ok,None) = governor.call(data) (src/RepresentativeCouncil.sol#65)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation
INFO:Detectors:
TimelockController._execute(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#412-415) has external calls inside a loop: (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#413)
        Calls stack containing the loop:
                TimelockController.executeBatch(address[],uint256[],bytes[],bytes32,bytes32)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop
INFO:Detectors:
Reentrancy in GovernorTimelockControl._executeOperations(uint256,address[],uint256[],bytes[],bytes32) (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#100-111):
        External calls:
        - _timelock.executeBatch{value: msg.value}(targets,values,calldatas,0,_timelockSalt(descriptionHash)) (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#108)
        State variables written after the call(s):
        - delete _timelockIds[proposalId] (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#110)
Reentrancy in NeighborGovernor.castVote(uint256,uint8) (src/NeighborGovernor.sol#55-58):
        External calls:
        - distributor.addPoint(_msgSender()) (src/NeighborGovernor.sol#56)
        State variables written after the call(s):
        - super.castVote(proposalId,support) (src/NeighborGovernor.sol#57)
                - proposalVote.hasVoted[account] = true (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#88)
                - proposalVote.againstVotes += totalWeight (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#91)
                - proposalVote.forVotes += totalWeight (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#93)
                - proposalVote.abstainVotes += totalWeight (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#95)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2
INFO:Detectors:
Reentrancy in NeighborGovernor.castVote(uint256,uint8) (src/NeighborGovernor.sol#55-58):
        External calls:
        - distributor.addPoint(_msgSender()) (src/NeighborGovernor.sol#56)
        Event emitted after the call(s):
        - VoteCast(account,proposalId,support,votedWeight,reason) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#664)
                - super.castVote(proposalId,support) (src/NeighborGovernor.sol#57)
        - VoteCastWithParams(account,proposalId,support,votedWeight,reason,params) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#666)
                - super.castVote(proposalId,support) (src/NeighborGovernor.sol#57)
Reentrancy in StreakDistributor.claim(uint256) (src/StreakDistributor.sol#74-88):
        External calls:
        - require(bool,string)(NRT.transfer(msg.sender,share),payout failed) (src/StreakDistributor.sol#86)
        Event emitted after the call(s):
        - Claimed(qtr,msg.sender,share) (src/StreakDistributor.sol#87)
Reentrancy in Governor.execute(address[],uint256[],bytes[],bytes32) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#416-451):
        External calls:
        - _executeOperations(proposalId,targets,values,calldatas,descriptionHash) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#441)
                - (success,returndata) = targets[i].call{value: values[i]}(calldatas[i]) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#468)
        Event emitted after the call(s):
        - ProposalExecuted(proposalId) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#448)
Reentrancy in TimelockController.execute(address,uint256,bytes,bytes32,bytes32) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#358-371):
        External calls:
        - _execute(target,value,payload) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#368)
                - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#413)
        Event emitted after the call(s):
        - CallExecuted(id,0,target,value,payload) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#369)
Reentrancy in TimelockController.executeBatch(address[],uint256[],bytes[],bytes32,bytes32) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#385-407):
        External calls:
        - _execute(target,value,payload) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#403)
                - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#413)
        Event emitted after the call(s):
        - CallExecuted(id,i,target,value,payload) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#404)
Reentrancy in StreakDistributor.finaliseQuarter(uint256) (src/StreakDistributor.sol#58-71):
        External calls:
        - require(bool,string)(NRT.transferFrom(msg.sender,address(this),poolAmt),transfer failed) (src/StreakDistributor.sol#62)
        Event emitted after the call(s):
        - QuarterFinalised(currentQtr,poolAmt,q.totalPoints) (src/StreakDistributor.sol#67)
Reentrancy in StreakDistributor.sweepRemainder(uint256,address) (src/StreakDistributor.sol#93-104):
        External calls:
        - require(bool,string)(NRT.transfer(to,due),transfer failed) (src/StreakDistributor.sol#102)
        Event emitted after the call(s):
        - RemainderSwept(qtr,due) (src/StreakDistributor.sol#103)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3
INFO:Detectors:
TimelockController.getOperationState(bytes32) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#207-218) uses timestamp for comparisons
        Dangerous comparisons:
        - timestamp == 0 (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#209)
        - timestamp == _DONE_TIMESTAMP (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#211)
        - timestamp > block.timestamp (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#213)
Votes.delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32) (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#143-162) uses timestamp for comparisons
        Dangerous comparisons:
        - block.timestamp > expiry (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#151)
ERC20Permit.permit(address,address,uint256,uint256,uint8,bytes32,bytes32) (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#44-67) uses timestamp for comparisons
        Dangerous comparisons:
        - block.timestamp > deadline (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#53)
Time._getFullAt(Time.Delay,uint48) (lib/openzeppelin-contracts/contracts/utils/types/Time.sol#74-80) uses timestamp for comparisons
        Dangerous comparisons:
        - effect <= timepoint (lib/openzeppelin-contracts/contracts/utils/types/Time.sol#79)
NeighborRewardToken._rollYear() (src/NRT.sol#47-53) uses timestamp for comparisons
        Dangerous comparisons:
        - block.timestamp >= yearStart + 31536000 (src/NRT.sol#48)
StreakDistributor.sweepRemainder(uint256,address) (src/StreakDistributor.sol#93-104) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(block.timestamp >= q.startTime + 7776000,grace) (src/StreakDistributor.sol#96)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp
INFO:Detectors:
Governor._unsafeReadBytesOffset(bytes,uint256) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#846-851) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/governance/Governor.sol#848-850)
Address._revert(bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#138-149) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Address.sol#142-145)
Panic.panic(uint256) (lib/openzeppelin-contracts/contracts/utils/Panic.sol#50-56) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Panic.sol#51-55)
ShortStrings.toString(ShortString) (lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#63-72) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#67-70)
StorageSlot.getAddressSlot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#66-70) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#67-69)
StorageSlot.getBooleanSlot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#75-79) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#76-78)
StorageSlot.getBytes32Slot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#84-88) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#85-87)
StorageSlot.getUint256Slot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#93-97) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#94-96)
StorageSlot.getInt256Slot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#102-106) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#103-105)
StorageSlot.getStringSlot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#111-115) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#112-114)
StorageSlot.getStringSlot(string) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#120-124) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#121-123)
StorageSlot.getBytesSlot(bytes32) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#129-133) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#130-132)
StorageSlot.getBytesSlot(bytes) (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#138-142) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#139-141)
Strings.toString(uint256) (lib/openzeppelin-contracts/contracts/utils/Strings.sol#45-63) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#50-52)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#55-57)
Strings.toChecksumHexString(address) (lib/openzeppelin-contracts/contracts/utils/Strings.sol#111-129) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#116-118)
Strings.escapeJSON(string) (lib/openzeppelin-contracts/contracts/utils/Strings.sol#446-476) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#470-473)
Strings._unsafeReadBytesOffset(bytes,uint256) (lib/openzeppelin-contracts/contracts/utils/Strings.sol#484-489) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Strings.sol#486-488)
ECDSA.tryRecover(bytes32,bytes) (lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#56-75) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#66-70)
MessageHashUtils.toEthSignedMessageHash(bytes32) (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#30-36) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#31-35)
MessageHashUtils.toDataWithIntendedValidatorHash(address,bytes32) (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#69-79) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#73-78)
MessageHashUtils.toTypedDataHash(bytes32,bytes32) (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#90-98) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#91-97)
Math.add512(uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#25-30) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#26-29)
Math.mul512(uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#37-46) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#41-45)
Math.tryMul(uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#73-84) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#76-80)
Math.tryDiv(uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#89-97) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#92-95)
Math.tryMod(uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#102-110) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#105-108)
Math.mulDiv(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#204-275) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#227-234)
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#240-249)
Math.tryModExp(uint256,uint256,uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#409-433) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#411-432)
Math.tryModExp(bytes,bytes,bytes) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#449-471) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#461-470)
Math.log2(uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#612-651) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#648-650)
SafeCast.toUint(bool) (lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#1157-1161) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#1158-1160)
Checkpoints._unsafeAccess(Checkpoints.Checkpoint224[],uint256) (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#215-223) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#219-222)
Checkpoints._unsafeAccess(Checkpoints.Checkpoint208[],uint256) (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#418-426) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#422-425)
Checkpoints._unsafeAccess(Checkpoints.Checkpoint160[],uint256) (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#621-629) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#625-628)
RepresentativeCouncil.signAndForward(address,RepresentativeCouncil.Impact,bytes) (src/RepresentativeCouncil.sol#49-68) uses assembly
        - INLINE ASM (src/RepresentativeCouncil.sol#64)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage
INFO:Detectors:
3 different versions of Solidity are used:
        - Version constraint ^0.8.20 is used by:
                -^0.8.20 (lib/openzeppelin-contracts/contracts/access/AccessControl.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/access/IAccessControl.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/Governor.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorSettings.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol#3)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#3)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC5267.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC5805.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#3)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Errors.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Nonces.sol#3)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Panic.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#5)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#5)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#5)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/structs/DoubleEndedQueue.sol#3)
                -^0.8.20 (lib/openzeppelin-contracts/contracts/utils/types/Time.sol#4)
        - Version constraint ^0.8.13 is used by:
                -^0.8.13 (src/Counter.sol#2)
        - Version constraint ^0.8.24 is used by:
                -^0.8.24 (src/NGT.sol#2)
                -^0.8.24 (src/NRT.sol#2)
                -^0.8.24 (src/NeighborGovernor.sol#2)
                -^0.8.24 (src/RepresentativeCouncil.sol#2)
                -^0.8.24 (src/StreakDistributor.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used
INFO:Detectors:
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - VerbatimInvalidDeduplication
        - FullInlinerNonExpressionSplitArgumentEvaluationOrder
        - MissingSideEffectsOnSelectorAccess.
It is used by:
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/access/AccessControl.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/access/IAccessControl.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/Governor.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorSettings.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol#3)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#3)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC5267.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC5805.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#3)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Context.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Errors.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Nonces.sol#3)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Panic.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#5)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#5)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#4)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#5)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/structs/DoubleEndedQueue.sol#3)
        - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/types/Time.sol#4)
Version constraint ^0.8.13 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - VerbatimInvalidDeduplication
        - FullInlinerNonExpressionSplitArgumentEvaluationOrder
        - MissingSideEffectsOnSelectorAccess
        - StorageWriteRemovalBeforeConditionalTermination
        - AbiReencodingHeadOverflowWithStaticArrayCleanup
        - DirtyBytesArrayToStorage
        - InlineAssemblyMemorySideEffects
        - DataLocationChangeInInternalOverride
        - NestedCalldataArrayAbiReencodingSizeValidation.
It is used by:
        - ^0.8.13 (src/Counter.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity
INFO:Detectors:
Low level call in Governor._executeOperations(uint256,address[],uint256[],bytes[],bytes32) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#460-471):
        - (success,returndata) = targets[i].call{value: values[i]}(calldatas[i]) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#468)
Low level call in Governor.relay(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#680-683):
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/Governor.sol#681)
Low level call in TimelockController._execute(address,uint256,bytes) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#412-415):
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#413)
Low level call in Address.sendValue(address,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#33-42):
        - (success,returndata) = recipient.call{value: amount}() (lib/openzeppelin-contracts/contracts/utils/Address.sol#38)
Low level call in Address.functionCallWithValue(address,bytes,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#75-81):
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#79)
Low level call in Address.functionStaticCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#87-90):
        - (success,returndata) = target.staticcall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#88)
Low level call in Address.functionDelegateCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#96-99):
        - (success,returndata) = target.delegatecall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#97)
Low level call in SignatureChecker.isValidERC1271SignatureNow(address,bytes32,bytes) (lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#38-49):
        - (success,result) = signer.staticcall(abi.encodeCall(IERC1271.isValidSignature,(hash,signature))) (lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#43-45)
Low level call in RepresentativeCouncil.signAndForward(address,RepresentativeCouncil.Impact,bytes) (src/RepresentativeCouncil.sol#49-68):
        - (ok,None) = governor.call(data) (src/RepresentativeCouncil.sol#65)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
INFO:Detectors:
Function Governor.CLOCK_MODE() (lib/openzeppelin-contracts/contracts/governance/Governor.sol#823) is not in mixedCase
Function IGovernor.COUNTING_MODE() (lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#202) is not in mixedCase
Function GovernorCountingSimple.COUNTING_MODE() (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#34-36) is not in mixedCase
Function GovernorVotes.CLOCK_MODE() (lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#46-52) is not in mixedCase
Function Votes.CLOCK_MODE() (lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#66-72) is not in mixedCase
Function IERC6372.CLOCK_MODE() (lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#16) is not in mixedCase
Function ERC20Permit.DOMAIN_SEPARATOR() (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#80-82) is not in mixedCase
Function IERC20Permit.DOMAIN_SEPARATOR() (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#89) is not in mixedCase
Function EIP712._EIP712Name() (lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#148-150) is not in mixedCase
Function EIP712._EIP712Version() (lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#159-161) is not in mixedCase
Variable NeighborGovToken.CAP (src/NGT.sol#22) is not in mixedCase
Variable NeighborGovToken.REGISTRAR (src/NGT.sol#23) is not in mixedCase
Variable NeighborRewardToken.CAP (src/NRT.sol#16) is not in mixedCase
Variable StreakDistributor.NRT (src/StreakDistributor.sol#18) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
INFO:Detectors:
ShortStrings.slitherConstructorConstantVariables() (lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#40-122) uses literals with too many digits:
        - FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF (lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#42)
Math.log2(uint256) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#612-651) uses literals with too many digits:
        - r = r | byte(uint256,uint256)(x >> r,0x0000010102020202030303030303030300000000000000000000000000000000) (lib/openzeppelin-contracts/contracts/utils/math/Math.sol#649)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#too-many-digits
INFO:Detectors:
NeighborGovernor.distributor (src/NeighborGovernor.sol#26) should be immutable
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-immutable
INFO:Slither:. analyzed (55 contracts with 100 detectors), 111 result(s) found

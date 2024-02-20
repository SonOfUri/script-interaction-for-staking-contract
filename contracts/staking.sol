// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract StakingContract {
    IERC20 public stakingToken;

    uint256 public constant APY = 10;  // 10% Annual Percentage Yield

    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakingStartTime;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0");
        stakedBalances[msg.sender] += amount;
        stakingStartTime[msg.sender] = block.timestamp;  // Set the staking start time

        // Transfer the staked tokens to this contract
        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Stake transfer failed");

        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "Nothing to unstake");

        // Calculate the reward
        uint256 reward = calculateReward(msg.sender);

        // Reset staked balance and staking start time
        stakedBalances[msg.sender] = 0;
        stakingStartTime[msg.sender] = 0;

        // Transfer the staked tokens and reward back to the user
        require(stakingToken.transfer(msg.sender, stakedAmount), "Unstake transfer failed");
        if (reward > 0) {
            require(stakingToken.transfer(msg.sender, reward), "Reward transfer failed");
            emit RewardPaid(msg.sender, reward);
        }

        emit Unstaked(msg.sender, stakedAmount);
    }

    function unstakeV2() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "Nothing to unstake");

        // Calculate the reward
        uint256 reward = calculateRewardV2(msg.sender);

        // Reset staked balance and staking start time
        stakedBalances[msg.sender] = 0;
        stakingStartTime[msg.sender] = 0;

        // Transfer the staked tokens and reward back to the user
        require(stakingToken.transfer(msg.sender, stakedAmount), "Unstake transfer failed");
        if (reward > 0) {
            require(stakingToken.transfer(msg.sender, reward), "Reward transfer failed");
            emit RewardPaid(msg.sender, reward);
        }

        emit Unstaked(msg.sender, stakedAmount);
    }

    function calculateReward(address user) public view returns (uint256) {
        uint256 stakedAmount = stakedBalances[user];
        if (stakedAmount == 0) return 0;

        uint256 stakingDuration = block.timestamp - stakingStartTime[user];
        uint256 reward = (stakedAmount * APY * stakingDuration) / (365 days * 100);
        return reward;
    }

    // // Advanced Reward
        function calculateRewardV2(address user) public view returns (uint256) {
        uint256 stakedAmount = stakedBalances[user];
        if (stakedAmount == 0) return 0;

        uint256 stakingDurationInDays = (block.timestamp - stakingStartTime[user]) / 1 days;
        uint256 dailyRate = APY / 36500;  // Assuming APY is provided as a percentage times 100

        // Compounding daily
        uint256 total = stakedAmount;
        for (uint256 i = 0; i < stakingDurationInDays; i++) {
            total += (total * dailyRate) / 10000;
        }

        // Subtract the initial stake to get just the reward
        uint256 reward = total - stakedAmount;
        return reward;
    }

}
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


# Mini-Exploits-Playground

Mini solidity Exploits example for learning.
<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

# Getting Start

## Requirement
- git
- foundry

## QuickStart
```
git clone https://github.com/kkontheway/Mini-Exploits-Playground.git
cd Mini-Exploits-Playground
forge install
```

## Test
```solidity
forge test
```

## Running a single test
```
forge test --mt test_functionName
```
## Todo
| Exploit                 | category                       | CTF-Practices | Status |
| ----------------------- | ------------------------------ | ------------- | ------ |
| Reentrancy              | Normal Reentrancy              |               |        |
|                         | ReadOnly Reentrancy            |               |        |
|                         | Cross Function Reentrancy      |               |        |
|                         | Cross-Contract Reentrancy      |               |        |
|                         | Cross-Chain Reentrancy         |               |        |
| Signature Reply         |                                |               |        |
| Over/Under Flow         |                                |               |        |
| Oracle Manipulation     |                                |               |        |
| DOS                     |                                |               |        |
| Weak Randomness         |                                |               |        |
| Missing Access Controls |                                |               |        |
| Proxy Attack            |                                |               |        |
| msg.value in a Loop     |                                |               |        |
| Flashloan Attack        |                                |               |        |
| DDOS                    | uint-to-enum                   |               | ✅      |
| Precision Loss          | Division Before Multiplication |               |        |



# Disclaimer

All code, practices, and patterns in this repository are used for educational purposes only.

!!! DO NOT USE IN PRODUCTION !!!

# Thank you!!!!

[contributors-shield]: https://img.shields.io/github/contributors/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[contributors-url]: https://github.com/kkontheway/Mini-Exploits-Playground/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[forks-url]: https://github.com/kkontheway/Mini-Exploits-Playground/network/members
[stars-shield]: https://img.shields.io/github/stars/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[stars-url]: https://github.com/kkontheway/Mini-Exploits-Playground/stargazers
[issues-shield]: https://img.shields.io/github/issues/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[issues-url]: https://github.com/kkontheway/Mini-Exploits-Playground/issues
[license-shield]: https://img.shields.io/github/license/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[license-url]: https://github.com/kkontheway/Mini-Exploits-Playground/LICENSE.txt

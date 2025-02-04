import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMORPG Stat Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StatCalculator(),
    );
  }
}

class StatCalculator extends StatefulWidget {
  @override
  _StatCalculatorState createState() => _StatCalculatorState();
}

class _StatCalculatorState extends State<StatCalculator> {
  // --- Character Stats ---
  double strength = 5;
  double agility = 5;
  double intelligence = 5;
  double perception = 5;
  double willpower = 5;
  double vitality = 5;
  double luck = 5;

  // --- Level ---
  int level = 1;

  // --- Available Stat Points ---
  double availablePoints = 15;

  // --- Weapon Damage and Armor ---
  double weaponDamage = 10;
  double baseArmor = 5;
  double baseMagicArmor = 5;

  // --- Coefficients ---
  double coefficientStrength = 0.05;
  double coefficientAgilityDamage = 0.02;
  double coefficientPerception = 0.10;
  double coefficientIntelligence = 0.15;
  double coefficientWillpower = 0.07;
  double coefficientLuckCrit = 0.0005;
  double coefficientLuckEvasion = 0.0001;
  double coefficientLuckEffectResist = 0.0002;
  double coefficientVitalityHealth = 25;
  double coefficientIntelligenceMana = 8;
  double coefficientWillpowerMana = 4;
  double coefficientEvasion = 0.015;
  double coefficientEffectResistance = 0.02;
  double coefficientStrengthArmor = 0.02;
  double coefficientVitalityArmor = 0.07;
  double coefficientIntelligenceMagicArmor = 0.03;
  double coefficientWillpowerMagicArmor = 0.05;

  // --- Calculated Stats ---
  double physicalDamageMelee = 0;
  double physicalDamageRanged = 0;
  double magicDamage = 0;
  double accuracy = 0;
  double criticalHitChance = 0;
  double effectChance = 0;
  double physicalArmor = 0;
  double magicArmor = 0;
  double evasion = 0;
  double effectResistance = 0;
  double health = 0;
  double mana = 0;

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  // --- Calculate Stats Function ---
  void _calculateStats() {
    double basePhysicalDamageMelee = weaponDamage + (strength * coefficientStrength);
    physicalDamageMelee = basePhysicalDamageMelee * (1 + (agility * coefficientAgilityDamage));

    double basePhysicalDamageRanged = weaponDamage + (perception * coefficientPerception);
    physicalDamageRanged = basePhysicalDamageRanged * (1 + (agility * coefficientAgilityDamage));

    magicDamage = (intelligence * coefficientIntelligence) + (willpower * coefficientWillpower);

    accuracy = min(0.95, 0.5 + (perception * 0.005) + (luck * 0.001));

    criticalHitChance = min(0.5, 0.05 + (agility * 0.003) + (luck * coefficientLuckCrit));

    effectChance = min(0.95, 0.7 + (intelligence * 0.001) + (luck * 0.0002));

    physicalArmor = baseArmor + (strength * coefficientStrengthArmor) + (vitality * coefficientVitalityArmor);

    magicArmor = baseMagicArmor + (intelligence * coefficientIntelligenceMagicArmor) + (willpower * coefficientWillpowerMagicArmor);

    evasion = min(0.75, 0.05 + (agility * coefficientEvasion) + (luck * coefficientLuckEvasion));

    effectResistance = (willpower * coefficientEffectResistance) + (luck * coefficientLuckEffectResist);

    health = 250 + (vitality * coefficientVitalityHealth);

    mana = 50 + (intelligence * coefficientIntelligenceMana) + (willpower * coefficientWillpowerMana);

    setState(() {});
  }

  // --- Level Up Function ---
  void _levelUp() {
    if (level < 150) {
      setState(() {
        level++;
        double levelUpPoints = 3 + (level - 50) * 0.01;
        availablePoints += levelUpPoints.floor(); // Round down
      });
      _calculateStats();
    }
  }

  // --- Increase Stat Function ---
  void _increaseStat(String statName) {
    if (availablePoints >= 1) {
      setState(() {
        availablePoints -= 1;
        switch (statName) {
          case 'strength':
            strength++;
            break;
          case 'agility':
            agility++;
            break;
          case 'intelligence':
            intelligence++;
            break;
          case 'perception':
            perception++;
            break;
          case 'willpower':
            willpower++;
            break;
          case 'vitality':
            vitality++;
            break;
          case 'luck':
            luck++;
            break;
        }
        _calculateStats();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MMORPG Stat Calculator'),
      ),
      body: Row(
        children: [
          // --- Left Side (Level, Stats) ---
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Level: $level'),
                ElevatedButton(
                  onPressed: _levelUp,
                  child: Text('Level Up'),
                ),
                Text('Available Points: ${availablePoints.toStringAsFixed(2)}'),

                SizedBox(height: 10),

                // Stat Increase Buttons
                _buildStatRow('Strength', strength, 'strength'),
                _buildStatRow('Agility', agility, 'agility'),
                _buildStatRow('Intelligence', intelligence, 'intelligence'),
                _buildStatRow('Perception', perception, 'perception'),
                _buildStatRow('Willpower', willpower, 'willpower'),
                _buildStatRow('Vitality', vitality, 'vitality'),
                _buildStatRow('Luck', luck, 'luck'),
              ],
            ),
          ),

          // --- Right Side (Stats Display) ---
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Physical Damage (Melee): ${physicalDamageMelee.toStringAsFixed(2)}'),
                  Text('Physical Damage (Ranged): ${physicalDamageRanged.toStringAsFixed(2)}'),
                  Text('Magic Damage: ${magicDamage.toStringAsFixed(2)}'),
                  Text('Accuracy: ${(accuracy * 100).toStringAsFixed(2)}%'),
                  Text('Critical Hit Chance: ${(criticalHitChance * 100).toStringAsFixed(2)}%'),
                  Text('Effect Chance: ${(effectChance * 100).toStringAsFixed(2)}%'),
                  Text('Physical Armor: ${physicalArmor.toStringAsFixed(2)}'),
                  Text('Magic Armor: ${magicArmor.toStringAsFixed(2)}'),
                  Text('Evasion: ${(evasion * 100).toStringAsFixed(2)}%'),
                  Text('Effect Resistance: ${effectResistance.toStringAsFixed(2)}'),
                  Text('Health: ${health.toStringAsFixed(2)}'),
                  Text('Mana: ${mana.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget for Stat Rows ---
  Widget _buildStatRow(String statName, double statValue, String increaseFunction) {
    return Row(
      children: [
        Text('$statName: ${statValue.toStringAsFixed(1)}'),
        IconButton(
          onPressed: () => _increaseStat(increaseFunction),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
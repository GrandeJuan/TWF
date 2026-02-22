# GAME DESIGN DOCUMENT — TWF: The Last Trench of Veranthos IV

## Lore & Universe

### The World: Veranthos IV
Veranthos IV is a Civilized World known for its metalurgical industry and vast ferronio mines — a high-density mineral used in armor manufacturing. The planet has two major continents connected by a narrow land bridge flanked by the Sea of Skareth, an ocean of dark violet waters saturated with heavy metals and organic acids that make navigation and sea life impossible.

### Continents
- **Korrabad** (west) — Lost to the Grakk invasion. Once the industrial heart of Veranthos IV, now ash and rubble.
- **Ferro Isthmus** (center) — The narrow land bridge, 80km at its narrowest. The main theater of war. Rocky, scarred terrain ideal for trench warfare.
- **Valdris Prime** (east) — Last human stronghold. Home to Valdris Secundus, the planetary capital and last major logistics hub.

### The Sea of Skareth
Toxic, unnavigable, and deadly. All logistics and transport on Veranthos IV is terrestrial or galactic. This geographic fact makes the Ferro Isthmus the only viable route for any ground advance — from either side.

### Factions

#### The Central Human Imperium
A militarized human civilization loosely inspired by iron-age imperial aesthetics mixed with grimdark sci-fi. Think bolt rifles, flak armor, disciplined regiments, and a culture that values sacrifice and order. They are outnumbered but technologically more disciplined.

**Key Figure:** General Commissar Kiras — cold, calculating, utterly devoted to holding the line. He is the player's avatar. All decisions are made in his name.

#### The Grakk
A brutal, semi-tribal alien warrior species inspired by the culture of Argentine football hooligans (barras bravas) mixed with grimdark sci-fi orks. They are loud, chaotic, physically massive, and driven by an almost religious frenzy for combat they call **"La Marea"** (The Tide).

Their hierarchy is based on who is the loudest, strongest, and most violent. Political decisions are made by whoever can hit hardest.

**Key Figure:** Supreme Grakk Ead'Crumpa — enormous even by Grakk standards, covered in trophies from conquered worlds, absolutely convinced that Veranthos IV will fall before him.

### Story Progression
1. Grakk fleet destroys Imperial orbital defenses. Korrabad falls in weeks.
2. General Commissar Kiras orders retreat to the Ferro Isthmus and begins digging.
3. The first trench line holds. The war of attrition begins.
4. The player defends through Early, Mid, and Late game phases.
5. Imperial reinforcements arrive. Humanity goes on the offensive.
6. Ead'Crumpa is defeated. Veranthos IV is saved.

---

## Game Flow

### Phase Loop
Every game cycle follows this order:

```
BASE (Command HQ) → MAP (World Map) → BATTLE (Trench Simulation)
```

After each battle resolves, the player returns to Base for the next cycle.

---

## Phase 1: Base — Command HQ

The player manages the war effort from a central command interface.

### Resources
- **Manpower** — soldiers available for assignment
- **Supplies** — ammunition, food, fuel for maintaining front lines
- **Requisition Points (RP)** — currency for purchasing upgrades, units, and doctrines

### Actions Available in Base
- **Research Doctrines** — spend RP to unlock tactical/technological advantages
- **Recruit Units** — spend Manpower and Supplies to add units to the roster
- **Handle Events** — random and scripted events that require player decisions
- **Review Intel** — see the status of all active fronts before going to the Map

### Doctrines
Doctrines are passive or active upgrades that affect battle behavior. Examples:
- *Concentrated Barrage* — unlocks artillery strike special action in battle
- *Iron Discipline* — units hold position longer before morale breaks
- *Forward Supplies* — reduces Supply drain during prolonged battles
- *Grakk Pattern Recognition* — events in battle give more information before choosing

Doctrines are organized in a research tree with tiers. Higher tiers require lower tier doctrines to be researched first.

---

## Phase 2: Map — World Map

A 2D top-down view of the Ferro Isthmus showing all active battle fronts.

### Player Actions
- Assign units to specific fronts
- Assign Supply levels to each front
- Activate previously researched doctrines per front
- Choose which fronts to prioritize (cannot win all simultaneously with limited resources)

### Front Status
Each front displays:
- Enemy pressure level (low / medium / high / critical)
- Current trench tier
- Assigned units and supplies
- Active doctrines

---

## Phase 3: Battle — Trench Simulation

A 2D side-scrolling real-time simulation. **Time is pausable at any moment.**

### Layout
- Human forces positioned on the RIGHT side of the screen
- Grakk forces advance from the LEFT
- Terrain includes trench lines, bunkers, barbed wire, craters, artillery positions

### What the Player Sees
- Units fighting autonomously based on assignments
- Health bars, morale indicators, and supply status
- Event notifications that require decisions
- Special action cooldown timers

### Player Actions During Battle
1. **Activate Doctrines** — toggle active doctrines that affect the battle in real time
2. **Respond to Events** — EU4/CK-style popup events with 2-3 choices, each with consequences
3. **Use Special Actions** — limited-use powerful interventions. Examples:
   - *Artillery Strike* — devastates a zone of the battlefield
   - *Emergency Reinforcements* — deploy reserves at a cost
   - *Commissar's Order* — temporarily boosts morale of a unit at narrative cost

### Battle Resolution
Battle ends when:
- Grakk forces are repelled (Human Victory)
- Human trench line is overrun (Human Defeat — triggers fallback or game over depending on phase)

There are no stalemates or negotiated outcomes. Every battle ends in a clear victory or defeat.

---

## Progression Structure

### Early Game — The Four Tiers
Four tiers of defensive positions between the edge of Korrabad and the entrance to the Ferro Isthmus. Each tier has **multiple simultaneous battles**. The player manages all fronts at once, prioritizing resources across them.

| Tier | Name | Description |
|------|------|-------------|
| 1 | The Outer Ruins | Shattered industrial outskirts of Korrabad. Minimal fortification. |
| 2 | The Ash Fields | Open terrain with improvised trenches. High Grakk pressure. |
| 3 | The Iron Ridges | Rocky elevated terrain. Better defensive position. |
| 4 | The Gate of Ferro | Last line before the Isthmus. Heavily fortified. Critical battles. |

### Mid Game — The Ferro Isthmus
One massive singular battle. No tiers, no multiple fronts. All resources converge on one epic defensive line across the narrowest point of the Isthmus. This is the climax of the defensive phase.

### Late Game — The Offensive
Reinforcements arrive. The dynamic inverts. Now the player attacks Grakk-held trench lines in Korrabad. The battle system is the same but the human forces advance from LEFT and Grakks defend on the RIGHT. Culminates in confrontation with Ead'Crumpa's command position.

---

## Events System

Events are inspired by Europa Universalis IV and Crusader Kings. They appear as popup cards during Base phase and Battle phase.

### Event Structure
Each event has:
- **Title** — e.g. "Deserters at the 3rd Line"
- **Flavor text** — narrative description of the situation
- **2-3 choices** — each with visible or hidden consequences
- **Consequences** — affect resources, morale, unit stats, or trigger follow-up events

### Example Events
**"Grakk Infiltrators Detected"**
> Intel reports a group of Grakk scouts has bypassed the front line and is causing chaos in the supply depot.
> A) Send a response squad (-1 unit from front, +supply security)
> B) Ignore and focus on the front (risk of supply loss next turn)
> C) Use it as bait to trap them (risky, potential big reward)

**"A Commissar's Doubt"**
> One of your junior officers questions the orders publicly. The men are watching.
> A) Publicly reprimand him (morale boost from discipline, officer efficiency drops)
> B) Hear him out privately (small morale cost, potential strategic insight gained)
> C) Remove him from command (immediate stability, long-term resentment in unit)

---

## Unit Stats System

Every unit — human or Grakk — has three core stats kept intentionally simple:

### Health
- Represents physical integrity of the unit
- Reduced by enemy attacks
- **If Health reaches 0: the unit is destroyed and removed from battle permanently**
- Cannot be recovered mid-battle (only partially between battles via supplies)

### Morale
- Represents the unit's psychological state and willingness to fight
- Reduced by casualties, failed events, supply shortages, and enemy pressure
- **If Morale reaches 0: a Morale Break Event is triggered (see below)**
- Can be partially restored by Commissar units, special actions, and positive events

#### Morale Break Event (inspired by Darkest Dungeon)
When a unit's Morale hits 0, one of two outcomes is randomly rolled — weighted by unit type, active doctrines, and context:

**BROKEN** — The unit routes. It retreats from the battle line and cannot be redeployed in this battle. May suffer permanent stat penalties if this happens repeatedly.

**INSPIRED** — Against all odds, the unit rallies. It receives a temporary combat buff (increased damage, resistance, or speed) and Morale is partially restored. Rare but can turn the tide of a battle.

The player has no direct control over which outcome occurs, but doctrines and special characters can shift the probability.

### Supply Level
- Represents ammunition, food, and material available to the unit
- Drains passively over time during battle
- **Affects both Damage output and Resistance (damage taken)**
  - Full supply: 100% damage and resistance
  - Low supply: reduced damage and resistance (e.g. 60%)
  - Empty supply: severe penalties, unit may trigger a Morale hit
- Replenished between battles via the Base phase ResourceManager
- Can be partially resupplied mid-battle via the *Forward Supplies* doctrine or special actions

---

## Special Characters

Special Characters are unique named individuals that can be assigned to specific trench fronts from the Base phase. They are not regular units — they provide passive bonuses or active abilities to the forces on that front.

### How They Work
- Assigned in the Base or Map phase to a specific front
- Provide their bonus for the duration of that battle
- Can be reassigned each cycle but only to one front at a time
- Some Special Characters can be lost if the front is overrun

### Example Special Characters

| Name | Role | Bonus |
|------|------|-------|
| Chaplain Maren | Spiritual officer | Morale Break chance shifts toward Inspired |
| Tech-Artificer Dorn | Equipment specialist | All units on front gain +Supply efficiency |
| Veteran Sergeant Hale | Experienced NCO | Units recover partial Morale after kills |
| Field Medic Sova | Combat medic | Slows Health loss rate across the front |
| Forward Observer Tenz | Artillery spotter | Reduces cooldown of Artillery Strike special action |

Special Characters are acquired through events, research milestones, or narrative progression.

### Grakk Special Characters

The Grakks also have unique named individuals that lead their forces on specific fronts. The player cannot control them but will be warned of their presence via intel events. Each Grakk Special Character makes the corresponding front significantly more dangerous and changes the battle dynamic.

| Name | Title | Effect |
|------|-------|--------|
| Ead'Crumpa | Supreme Grakk | Final endgame boss. Present only in the last battle. Massively buffs all Grakk units and triggers La Marea repeatedly. |
| Granka "La Maza" | Front Commander | Grakk units on this front never route — Morale Break always resolves as Inspired for Grakks |
| Skabb el Ruidoso | Wardrummer Prime | La Marea frenzy activates twice as often and lasts longer |
| Vrukk Dientesrotos | Siege Specialist | Grakk units deal bonus damage to trench fortifications and cover |
| Maga la Bruja | Grakk Shaman | Triggers negative events more frequently on the human side of the front |
| El Gordo Rojo | Supply Raider | Human Supply drain rate on this front is doubled |

Grakk Special Characters are revealed gradually through the intel system. The player may learn one is present only after the battle has started, forcing adaptation mid-fight.

---

## Unit Types (Initial Design)

### Human Units
| Unit | Role |
|------|------|
| Line Infantry | Basic frontline soldiers |
| Heavy Gunners | Suppression and area denial |
| Combat Engineers | Build/repair trench fortifications during battle |
| Commissar Squad | Morale enforcement — shifts Morale Break toward Inspired |
| Artillery Battery | Ranged bombardment (activated via doctrine) |

### Grakk Units
| Unit | Role |
|------|------|
| Grakk Mob | Chaotic mass charge infantry |
| Big Grakk | Heavy melee bruiser |
| Scrap Gunner | Unreliable but high damage ranged unit |
| Wardrummer | Support unit that buffs nearby Grakks — triggers La Marea morale frenzy |
| Rampage Beast | Large creature used as living battering ram |

---

## Visual & Audio Direction

### Art Style
Gritty 2D. Dark palette with high contrast. Inspired by WW1 trench warfare art mixed with sci-fi elements. Think mud, barbed wire, muzzle flashes, and alien silhouettes on the horizon.

### Audio Direction
- Ambient: artillery in the distance, wind, rain on metal
- Battle: chaotic percussion, shouting, weapon fire
- Grakk theme: distorted drums, crowd chanting energy (barra brava-inspired)
- Human theme: military brass, disciplined and somber

---

## Out of Scope (for initial build)
- Multiplayer
- Procedurally generated maps
- Full voice acting
- Naval or aerial combat

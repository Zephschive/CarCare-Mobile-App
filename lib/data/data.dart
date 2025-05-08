/// A single maintenance tip
class MaintenanceTip {
  final String title;
  final String description;

  const MaintenanceTip({required this.title, required this.description});
}

/// Full pool of maintenance tips
const List<MaintenanceTip> allMaintenanceTips = [
  MaintenanceTip(
    title: "Rotate Tires",
    description:
        "Rotate your tires every 5,000–7,500 miles to promote even wear and extend their lifespan.",
  ),
  MaintenanceTip(
    title: "Check Tire Pressure",
    description:
        "Perform monthly tire pressure checks—under-inflation reduces fuel economy and can lead to premature wear.",
  ),
  MaintenanceTip(
    title: "Inspect Tread Depth",
    description:
        "Use a tread-depth gauge to ensure your tires have at least 2/32\" of tread; replace if worn below safe levels.",
  ),
  MaintenanceTip(
    title: "Replace Air Filter",
    description:
        "Swap out your engine air filter annually or every 12,000 miles to maintain airflow and engine efficiency.",
  ),
  MaintenanceTip(
    title: "Check Oil Level",
    description:
        "Monitor your engine oil level weekly and top off as needed to prevent internal wear and overheating.",
  ),
  MaintenanceTip(
    title: "Change Engine Oil",
    description:
        "Change your oil every 3,000–7,500 miles, depending on your vehicle’s spec, to protect engine internals.",
  ),
  MaintenanceTip(
    title: "Wax Car",
    description:
        "Wax your paint every three months to add a protective barrier against UV rays, road salt, and grime.",
  ),
  MaintenanceTip(
    title: "Test Headlights",
    description:
        "Monthly, turn on your headlights and walk around the car to confirm each bulb is bright and aligned.",
  ),
  MaintenanceTip(
    title: "Inspect Brake Pads",
    description:
        "Listen for squealing or grinding; replace brake pads before they wear thin enough to damage rotors.",
  ),
  MaintenanceTip(
    title: "Monitor Engine Temp",
    description:
        "Keep an eye on your temperature gauge—if it climbs above normal, you may have cooling system issues.",
  ),
  MaintenanceTip(
    title: "Clean Air Vents",
    description:
        "Blow compressed air through dashboard vents quarterly to prevent dust buildup and maintain airflow.",
  ),
  MaintenanceTip(
    title: "Vacuum Interior",
    description:
        "Vacuum carpets and seats weekly to remove debris that can cause wear and odors over time.",
  ),
  MaintenanceTip(
    title: "Inspect Wiper Blades",
    description:
        "Check blades monthly for cracks or tears—replace every 6–12 months to ensure a clear windshield.",
  ),
  MaintenanceTip(
    title: "Check Battery Voltage",
    description:
        "Use a multimeter monthly to verify your battery holds 12.4–12.7 volts when the engine is off.",
  ),
  MaintenanceTip(
    title: "Lubricate Hinges",
    description:
        "Apply a drop of white lithium grease to door hinges twice a year to prevent squeaks and rust.",
  ),
  MaintenanceTip(
    title: "Flush Coolant",
    description:
        "For optimal engine life, flush and replace coolant every 2–3 years according to your manual.",
  ),
  MaintenanceTip(
    title: "Check Brake Fluid",
    description:
        "Inspect brake fluid level monthly; low fluid can indicate leaks and compromise stopping power.",
  ),
  MaintenanceTip(
    title: "Rotate Seasonal Tires",
    description:
        "If you swap winter and summer tires, rotate them upon installation to even out wear patterns.",
  ),
  MaintenanceTip(
    title: "Align Wheels",
    description:
        "Have a professional align your wheels annually or after hitting a curb to avoid uneven tire wear.",
  ),
  MaintenanceTip(
    title: "Inspect Suspension",
    description:
        "Listen for clunks or excessive bounce over bumps and have shocks/struts inspected if noise persists.",
  ),
];

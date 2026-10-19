const githubUrl = 'https://github.com/PyreCore';

class Project {
  const Project({
    required this.name,
    required this.tags,
    required this.description,
    required this.url,
  });

  final String name;
  final String tags;
  final String description;
  final String url;
}

const projects = [
  Project(
    name: 'jarvis-OS',
    tags: 'Python · AI · Voice',
    description: 'Real-time AI voice personal assistant.',
    url: 'https://github.com/PyreCore/jarvis-OS',
  ),
  Project(
    name: 'medigo',
    tags: 'Web · Booking',
    description: 'Hospital appointment booking platform.',
    url: 'https://github.com/PyreCore/medigo',
  ),
  Project(
    name: 'powershel_Admin',
    tags: 'PowerShell · Windows',
    description: 'Windows system status reporting & admin toolkit with alerts and CSV export.',
    url: 'https://github.com/PyreCore/powershel_Admin',
  ),
  Project(
    name: 'Linux_Admin',
    tags: 'Bash · Linux',
    description: 'Linux system administration scripts and tooling.',
    url: 'https://github.com/PyreCore/Linux_Admin',
  ),
];

const skills = [
  'Python',
  'Artificial Intelligence / LLMs',
  'Automation & Scripting',
  'PowerShell',
  'Bash / Linux',
  'HTML · CSS · JavaScript',
  'Git & GitHub',
];

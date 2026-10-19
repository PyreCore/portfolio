import 'package:flutter/material.dart' show IconData, Icons;

import 'l10n.dart';

const githubUrl = 'https://github.com/PyreCore';

class Project {
  const Project({
    required this.name,
    required this.icon,
    required this.tags,
    required this.description,
    required this.url,
  });

  final String name;
  final IconData icon;
  final T tags;
  final T description;
  final String url;
}

const projects = [
  Project(
    name: 'jarvis-OS',
    icon: Icons.graphic_eq_rounded,
    tags: T('Python · AI · Voice', 'Python · IA · Voix'),
    description: T(
      'A real-time, AI-powered personal voice assistant: speak to your '
          'computer and it answers.',
      'Un assistant vocal personnel propulsé par l’IA, en temps réel : vous '
          'parlez à votre ordinateur, il vous répond.',
    ),
    url: 'https://github.com/PyreCore/jarvis-OS',
  ),
  Project(
    name: 'medigo',
    icon: Icons.local_hospital_rounded,
    tags: T('Web · Booking', 'Web · Réservation'),
    description: T(
      'A web platform to book hospital appointments online, simply and '
          'quickly.',
      'Une plateforme web pour réserver ses rendez-vous à l’hôpital en '
          'ligne, simplement et rapidement.',
    ),
    url: 'https://github.com/PyreCore/medigo',
  ),
  Project(
    name: 'powershel_Admin',
    icon: Icons.terminal_rounded,
    tags: T.same('PowerShell · Windows'),
    description: T(
      'A Windows admin toolkit: system status reports, alerts and CSV '
          'export.',
      'Une boîte à outils d’administration Windows : rapports d’état '
          'système, alertes et export CSV.',
    ),
    url: 'https://github.com/PyreCore/powershel_Admin',
  ),
  Project(
    name: 'Linux_Admin',
    icon: Icons.dns_rounded,
    tags: T.same('Bash · Linux'),
    description: T(
      'A collection of Bash scripts and tools for Linux system '
          'administration.',
      'Une collection de scripts Bash et d’outils pour l’administration '
          'de systèmes Linux.',
    ),
    url: 'https://github.com/PyreCore/Linux_Admin',
  ),
];

class FocusArea {
  const FocusArea({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final T title;
  final T text;
}

const focusAreas = [
  FocusArea(
    icon: Icons.auto_awesome_rounded,
    title: T('AI assistants', 'Assistants IA'),
    text: T(
      'Voice and LLM-powered tools.',
      'Des outils vocaux et basés sur les LLM.',
    ),
  ),
  FocusArea(
    icon: Icons.bolt_rounded,
    title: T('Automation', 'Automatisation'),
    text: T(
      'Scripts that take care of the repetitive work.',
      'Des scripts qui s’occupent du travail répétitif.',
    ),
  ),
  FocusArea(
    icon: Icons.settings_suggest_rounded,
    title: T('System administration', 'Administration système'),
    text: T(
      'Tooling for Windows and Linux.',
      'Des outils pour Windows et Linux.',
    ),
  ),
];

const skills = [
  T.same('Python'),
  T('Artificial Intelligence / LLMs', 'Intelligence artificielle / LLM'),
  T('Automation & Scripting', 'Automatisation & scripting'),
  T.same('PowerShell'),
  T.same('Bash / Linux'),
  T.same('HTML · CSS · JavaScript'),
  T.same('Git & GitHub'),
];

/// Textes de l'interface.
abstract final class Txt {
  static const appTitle = T(
    'PyreCore — Developer Portfolio',
    'PyreCore — Portfolio de développeur',
  );

  static const navAbout = T('About', 'À propos');
  static const navProjects = T('Projects', 'Projets');
  static const navSkills = T('Skills', 'Compétences');
  static const navContact = T.same('Contact');

  static const heroBadge = T(
    'Open to collaborations',
    'Ouvert aux collaborations',
  );
  static const heroEyebrow = T('Hi, I’m', 'Salut, moi c’est');
  static const heroTagline = T(
    'Python developer crafting AI assistants and automation tools — '
        'software that makes computers feel alive.',
    'Développeur Python, je crée des assistants IA et des outils '
        'd’automatisation — des logiciels qui donnent vie aux ordinateurs.',
  );
  static const heroCta = T('See my work', 'Voir mes projets');
  static const heroGithub = T.same('GitHub');
  static const scroll = T('Scroll', 'Défiler');

  static const aboutSubtitle = T(
    'Who I am and what drives me.',
    'Qui je suis et ce qui me motive.',
  );
  static const aboutText = T(
    'I build things that automate the boring and amplify the interesting. '
        'From a real-time AI voice assistant to admin toolkits that keep Windows '
        'and Linux machines in check, I love practical tools, clean scripts and '
        'small products that solve real problems — one project at a time.',
    'Je construis des outils qui automatisent le répétitif et amplifient '
        'l’intéressant. D’un assistant vocal IA en temps réel à des boîtes à '
        'outils qui gardent les machines Windows et Linux sous contrôle, j’aime '
        'créer des outils concrets, des scripts propres et de petits produits qui '
        'résolvent de vrais problèmes — un projet à la fois.',
  );

  static const projectsSubtitle = T(
    'A selection of what I’ve been building.',
    'Une sélection de ce que je construis.',
  );
  static const projectLink = T('View on GitHub', 'Voir sur GitHub');

  static const skillsSubtitle = T('My toolbox.', 'Ma boîte à outils.');

  static const contactSubtitle = T(
    'Got an idea or a project? Let’s talk.',
    'Une idée ou un projet ? Parlons-en.',
  );
  static const contactHeading = T(
    'Let’s build something together.',
    'Construisons quelque chose ensemble.',
  );
  static const contactText = T(
    'I’m open to collaborations and interesting projects. The easiest way to '
        'reach me is on GitHub.',
    'Je suis ouvert aux collaborations et aux projets intéressants. Le plus '
        'simple pour me joindre, c’est sur GitHub.',
  );
  static const contactCta = T('Reach me on GitHub', 'Me contacter sur GitHub');

  static const footer = T('Built with Flutter.', 'Conçu avec Flutter.');
}

import 'package:flutter/widgets.dart';
import 'package:law_app/screens/budget.dart';
import 'package:law_app/screens/constitution.dart';
import 'package:law_app/screens/downloads.dart';
import 'package:law_app/screens/downloads/committees_reports.dart';
import 'package:law_app/screens/downloads/gazetted_acts.dart';
import 'package:law_app/screens/downloads/govt_agreement.dart';
import 'package:law_app/screens/downloads/officail_report.dart';
import 'package:law_app/screens/downloads/research_materials.dart';
import 'package:law_app/screens/home.dart';
import 'package:law_app/screens/online_forum.dart';
import 'package:law_app/screens/parliament.dart';
import 'package:law_app/screens/parliament/aboutus.dart';
import 'package:law_app/screens/parliament/parliament_calendar.dart';
import 'package:law_app/screens/parliament/parliament_chief_members.dart';
import 'package:law_app/screens/parliament/parliament_clerk.dart';
import 'package:law_app/screens/parliament/parliament_directory.dart';
import 'package:law_app/screens/parliament/parliament_members.dart';
import 'package:law_app/screens/parliament/parliament_speaker.dart';
import 'package:law_app/screens/splash_screen.dart';
import 'package:law_app/screens/standing_order.dart';
import 'package:law_app/screens/state_opining.dart';
import 'package:law_app/screens/video_streaming.dart';
import 'package:law_app/screens/votes.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder> {
  '/' : (BuildContext context) => SplashScreen(),

  '/homeScreen': (BuildContext context) => new HomeScreen(),
  '/parliamentScreen': (BuildContext context) => new ParliamentScreen(),
  '/downloadsScreen': (BuildContext context) => new DownloadsScreen(),
  '/onlineForumScreen': (BuildContext context) => new OnlineForumScreen(),
  '/votesScreen': (BuildContext context) => new VotesScreen(),
  '/standingOrderScreen': (BuildContext context) => new StandingOrderScreen(),
  '/constitutionScreen': (BuildContext context) => new ConstitutionScreen(),
  '/stateOpeningScreen': (BuildContext context) => new StateOpeningScreen(),
  '/budgetScreen': (BuildContext context) => new BudgetScreen(),
  '/gazettedActsScreen': (BuildContext context) => new GazettedActsScreen(),
  '/govtAgreementScreen': (BuildContext context) => new GovtAgreementScreen(),
  '/officialReportScreen': (BuildContext context) => new OfficailReportScreen(),
  '/committeesReportsScreen': (BuildContext context) => new CommitteesReportsScreen(),
  '/researchMaterilasScreen': (BuildContext context) => new ResearchMaterialsScreen(),
  '/aboutUsScreen': (BuildContext context) => new AboutUsScreen(),
  '/parliamentMembersScreen': (BuildContext context) => new ParliamentMembersScreen(),
  '/parliamentChiefMembersScreen': (BuildContext context) => new ParliamentChiefMembersScreen(),
  '/parliamentSpeakerScreen': (BuildContext context) => new ParliamentSpeakerScreen(),
  '/parliamentDirectoryScreen': (BuildContext context) => new ParliamentDirectoryScreen(),
  '/parliamentClerkScreen': (BuildContext context) => new ParliamentClerkScreen(),
  '/parliamentCalendarScreen': (BuildContext context) => new ParliamentCalendarScreen(),
  '/videoStreamingScreen': (BuildContext context) => new VideoStreamingScreen(),
};

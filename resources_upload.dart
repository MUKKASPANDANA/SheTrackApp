import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Upload extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> articles = [
  {
    "type": "article",
    "title": "10132 menstrual cycle",
    "description": "",
    "url": "https://my.clevelandclinic.org/health/articles/10132-menstrual-cycle",
    "thumbnailUrl": null,
    "authorOrSource": "my.clevelandclinic.org",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "Menstruation",
    "description": "",
    "url": "https://kidshealth.org/en/teens/menstruation.html",
    "thumbnailUrl": null,
    "authorOrSource": "kidshealth.org",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "Term menstruation 5bmajr 3anoexp 5d and female 5bmh 5d or menstruation disturbances 5bmajr 3anoexp 5d and female 5bmh 5d and humans 5bmh 5d and english 5bla 5d and last 1 year 5bedat 5d not letter 5bpt 5d or case reports 5bpt 5d or editorial 5bpt 5d or comment 5bpt 5d and free full text 5bsb 5d",
    "description": "",
    "url": "https://pubmed.ncbi.nlm.nih.gov/?term=%22Menstruation%22%5Bmajr%3Anoexp%5D+AND+female+%5Bmh%5D+OR+%22Menstruation+Disturbances%22%5Bmajr%3Anoexp%5D+AND+female+%5Bmh%5D+AND+humans%5Bmh%5D+AND+english%5Bla%5D+AND+%22last+1+Year%22+%5Bedat%5D+NOT+%28letter%5Bpt%5D+OR+case+reports%5Bpt%5D+OR+editorial%5Bpt%5D+OR+comment%5Bpt%5D%29+AND+free+full+text%5Bsb%5D+&_ga=2.200214638.1784057890.1745428146-179951722.1745428146",
    "thumbnailUrl": null,
    "authorOrSource": "pubmed.ncbi.nlm.nih.gov",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "40239029",
    "description": "",
    "url": "https://pubmed.ncbi.nlm.nih.gov/40239029/",
    "thumbnailUrl": null,
    "authorOrSource": "pubmed.ncbi.nlm.nih.gov",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "40251620",
    "description": "",
    "url": "https://pubmed.ncbi.nlm.nih.gov/40251620/",
    "thumbnailUrl": null,
    "authorOrSource": "pubmed.ncbi.nlm.nih.gov",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "40255381",
    "description": "",
    "url": "https://pubmed.ncbi.nlm.nih.gov/40255381/",
    "thumbnailUrl": null,
    "authorOrSource": "pubmed.ncbi.nlm.nih.gov",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "312661#menstrual cycle problems",
    "description": "",
    "url": "https://www.medicalnewstoday.com/articles/312661#menstrual-cycle-problems",
    "thumbnailUrl": null,
    "authorOrSource": "medicalnewstoday.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "S0002937820306190",
    "description": "",
    "url": "https://www.sciencedirect.com/science/article/pii/S0002937820306190",
    "thumbnailUrl": null,
    "authorOrSource": "sciencedirect.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "Menstruation in girls and adolescents using the menstrual cycle as a vital sign",
    "description": "",
    "url": "https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign",
    "thumbnailUrl": null,
    "authorOrSource": "acog.org",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "Menstrual cups are safe and sustainable but they can be tricky for first time users our new study shows 246045",
    "description": "",
    "url": "https://theconversation.com/menstrual-cups-are-safe-and-sustainable-but-they-can-be-tricky-for-first-time-users-our-new-study-shows-246045",
    "thumbnailUrl": null,
    "authorOrSource": "theconversation.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "Menstrual cycle is a vital sign and important indicator of overall health 2 reproductive health experts explain 229883",
    "description": "",
    "url": "https://theconversation.com/menstrual-cycle-is-a-vital-sign-and-important-indicator-of-overall-health-2-reproductive-health-experts-explain-229883",
    "thumbnailUrl": null,
    "authorOrSource": "theconversation.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "The long and strange history of testing menstrual blood for health conditions 233507",
    "description": "",
    "url": "https://theconversation.com/the-long-and-strange-history-of-testing-menstrual-blood-for-health-conditions-233507",
    "thumbnailUrl": null,
    "authorOrSource": "theconversation.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "Got period pain or cramps what to eat and avoid according to science 218344",
    "description": "",
    "url": "https://theconversation.com/got-period-pain-or-cramps-what-to-eat-and-avoid-according-to-science-218344",
    "thumbnailUrl": null,
    "authorOrSource": "theconversation.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "How much period blood is normal and which sanitary product holds the most blood 211418",
    "description": "",
    "url": "https://theconversation.com/how-much-period-blood-is-normal-and-which-sanitary-product-holds-the-most-blood-211418",
    "thumbnailUrl": null,
    "authorOrSource": "theconversation.com",
    "color": "#FFCC80"
  },
  {
    "type": "article",
    "title": "From rags and pads to the sanitary apron a brief history of period products 203451",
    "description": "",
    "url": "https://theconversation.com/from-rags-and-pads-to-the-sanitary-apron-a-brief-history-of-period-products-203451",
    "thumbnailUrl": null,
    "authorOrSource": "theconversation.com",
    "color": "#FFCC80"
  },
];


  List<Map<String, dynamic>> videos = [
  {
    "type": "video",
    "title": "Menstrual Cycle - 3D",
    "description": "",
    "url": "https://www.youtube.com/watch?v=F3VXp9bB1hQ",
    "thumbnailUrl": null,
    "authorOrSource": "YouTube",
    "color": "#90CAF9"
  },
  {
    "type": "video",
    "title": "The menstrual cycle",
    "description": "",
    "url": "https://www.youtube.com/watch?v=2eVGwJ5jdts",
    "thumbnailUrl": null,
    "authorOrSource": "YouTube",
    "color": "#90CAF9"
  },
  {
    "type": "video",
    "title": "What Happens During Your Menstrual Cycle?",
    "description": "",
    "url": "https://www.youtube.com/watch?v=vcH97Dx8VCk",
    "thumbnailUrl": null,
    "authorOrSource": "YouTube",
    "color": "#90CAF9"
  },
  {
    "type": "video",
    "title": "Menstrual Cycle Hormones Made Easy",
    "description": "",
    "url": "https://www.youtube.com/watch?v=RX6GvsiyfRg",
    "thumbnailUrl": null,
    "authorOrSource": "YouTube",
    "color": "#90CAF9"
  },
  {
    "type": "video",
    "title": "What Is a Normal Menstrual Cycle?",
    "description": "",
    "url": "https://www.youtube.com/watch?v=W45RFvB-YvI",
    "thumbnailUrl": null,
    "authorOrSource": "YouTube",
    "color": "#90CAF9"
  },
  {
    "type": "video",
    "title": "The Menstrual Cycle - Explained with Animation",
    "description": "",
    "url": "https://www.youtube.com/watch?v=kaPpEUZ-8dY",
    "thumbnailUrl": null,
    "authorOrSource": "YouTube",
    "color": "#90CAF9"
  },
];


  Future<void> uploadHealthResources() async {
    try {
      final batch = _firestore.batch();

      // Upload articles
      for (final article in articles) {
        final docRef = _firestore.collection('articles').doc();
        batch.set(docRef, article);
      }

      // Upload videos
      for (final video in videos) {
        final docRef = _firestore.collection('videos').doc();
        batch.set(docRef, video);
      }

      // Commit all changes in a single batch
      await batch.commit();
      debugPrint("✅ Uploaded all resources to Firestore!");
    } catch (e) {
      debugPrint("❌ Error uploading resources: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Health Resources'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await uploadHealthResources();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload completed!')),
            );
          },
          child: Text('Upload Resources'),
        ),
      ),
    );
  }
}

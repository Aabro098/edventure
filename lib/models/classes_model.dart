class Institution {
  final String institutionName;
  final List<ClassOffering> classOfferings;

  Institution({
    required this.institutionName,
    required this.classOfferings,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    var offeringsJson = json['class_offerings'] as List;
    List<ClassOffering> offeringsList = offeringsJson
        .map((offering) => ClassOffering.fromJson(offering))
        .toList();

    return Institution(
      institutionName: json['institution_name'],
      classOfferings: offeringsList,
    );
  }
}

class ClassOffering {
  final String title;
  final String subject;
  final int availableSlots;
  final double price;
  final String duration;
  final String schedule;
  final String description;
  final String instructor;
  final int studentsEnrolled;
  final int studentsCompleted;
  final int studentsRated;
  final bool acceptingRegistrations;
  final DateTime startDate;
  final DateTime endDate;
  final String thumbnail;
  final String id;

  ClassOffering({
    required this.title,
    required this.subject,
    required this.availableSlots,
    required this.price,
    required this.duration,
    required this.schedule,
    required this.description,
    required this.instructor,
    required this.studentsEnrolled,
    required this.studentsCompleted,
    required this.studentsRated,
    required this.acceptingRegistrations,
    required this.startDate,
    required this.endDate,
    required this.thumbnail,
    required this.id,
  });

  factory ClassOffering.fromJson(Map<String, dynamic> json) {
    return ClassOffering(
      title: json['title'],
      subject: json['subject'],
      availableSlots: json['available_slots'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      schedule: json['schedule'],
      description: json['description'],
      instructor: json['instructor'],
      studentsEnrolled: json['students_enrolled'],
      studentsCompleted: json['students_completed'],
      studentsRated: json['students_rated'],
      acceptingRegistrations: json['accepting_registrations'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      thumbnail: json['thumbnail'],
      id: json['_id'],
    );
  }
}

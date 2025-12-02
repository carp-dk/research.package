part of '../main.dart';

RPOrderedTask get consentTask {
  RPConsentSection overviewSection = RPConsentSection(
      type: RPConsentSectionType.Overview,
      summary: "overview.title",
      content: "overview.content");

  RPConsentSection dataGatheringSection = RPConsentSection(
      type: RPConsentSectionType.DataGathering,
      summary: "datagathering.title",
      content: "datagathering.content");
  RPConsentSection privacySection = RPConsentSection(
      type: RPConsentSectionType.Privacy,
      summary: "privacy.title",
      content: "privacy.content");

  RPConsentSection dataUseSection = RPConsentSection(
      type: RPConsentSectionType.DataUse,
      summary: "This is a summary for Data Use.",
      content: "Data Use dolor sit amet");

  RPConsentSection timeCommitmentSection = RPConsentSection(
      type: RPConsentSectionType.TimeCommitment,
      summary: "This is a summary for Time Commitment.",
      content:
          "Time commitment dolor sit amet, consectetur adipiscing elit. Aenean a mi porttitor, bibendum elit elementum, placerat augue. Quisque eu sollicitudin tortor, sed egestas ante. Sed convallis, mauris quis malesuada convallis, lectus ante vestibulum ante, vel lobortis magna dui eu nisl. Proin ac pellentesque nulla. Morbi facilisis dui aliquam quam pulvinar efficitur. Duis at lorem vitae leo pharetra ultricies. Proin viverra eleifend varius. Nulla sed nisi ut enim placerat venenatis. Maecenas imperdiet accumsan ligula id varius. Donec rhoncus gravida odio vitae convallis.Nullam at tempor erat. Praesent euismod orci nec sollicitudin placerat. Nunc nec nibh efficitur, mattis ante sit amet, scelerisque libero. Aliquam et mollis erat. Pellentesque aliquam convallis turpis sit amet molestie. Duis accumsan venenatis imperdiet. Integer quis est non elit varius mattis. Donec hendrerit in nisl eget sollicitudin. Nulla sapien lacus, mattis non orci sed, commodo tincidunt risus.");

  RPConsentSection durationSection = RPConsentSection(
      type: RPConsentSectionType.Duration,
      summary: "This is a summary for Duration.",
      content: "Duration dolor sit amet");

  RPConsentSection studyTasksSection = RPConsentSection(
      title: "What should you do?",
      type: RPConsentSectionType.StudyTasks,
      summary: "This is a summary for Study Tasks.",
      content: "Study Tasks dolor sit amet");

  RPConsentSection studySurveySection = RPConsentSection(
      type: RPConsentSectionType.StudySurvey,
      summary: "This is a summary for Study Survey.",
      content: "Study Survey dolor sit amet");

  RPConsentSection withdrawingSection = RPConsentSection(
      type: RPConsentSectionType.Withdrawing,
      summary: "This is a summary for Withdrawing.",
      content: "Withdrawing dolor sit amet");

  RPConsentSection yourRightsSection = RPConsentSection(
      type: RPConsentSectionType.YourRights,
      summary: "This is a summary for Your Rights.",
      content: "Your Rights dolor sit amet");

  RPConsentSection welcomeSection = RPConsentSection(
      type: RPConsentSectionType.Welcome,
      summary: "This is a summary for Welcome.",
      content: "Welcome dolor sit amet");

  RPConsentSection aboutUs = RPConsentSection(
      type: RPConsentSectionType.AboutUs,
      summary: "This is a summary for About Us.",
      content:
          "About Us dolor sit amet, consectetur adipiscing elit. Aenean a mi porttitor, bibendum elit elementum, placerat augue. Quisque eu sollicitudin tortor, sed egestas ante. Sed convallis, mauris quis malesuada convallis, lectus ante vestibulum ante, vel lobortis magna dui eu nisl. Proin ac pellentesque nulla. Morbi facilisis dui aliquam quam pulvinar efficitur. Duis at lorem vitae leo pharetra ultricies. Proin viverra eleifend varius. Nulla sed nisi ut enim placerat venenatis. Maecenas imperdiet accumsan ligula id varius. Donec rhoncus gravida odio vitae convallis.Nullam at tempor erat. Praesent euismod orci nec sollicitudin placerat. Nunc nec nibh efficitur, mattis ante sit amet, scelerisque libero. Aliquam et mollis erat. Pellentesque aliquam convallis turpis sit amet molestie. Duis accumsan venenatis imperdiet. Integer quis est non elit varius mattis. Donec hendrerit in nisl eget sollicitudin. Nulla sapien lacus, mattis non orci sed, commodo tincidunt risus.");

  RPConsentSection goalsSection = RPConsentSection(
      type: RPConsentSectionType.Goals,
      summary: "This is a summary for Goals.",
      content: "Goals dolor sit amet");

  RPConsentSection benefitsSection = RPConsentSection(
      type: RPConsentSectionType.Benefits,
      summary: "This is a summary for Benefits.",
      content: "Benefits dolor sit amet");

  RPConsentSection dataHandlingSection = RPConsentSection(
      type: RPConsentSectionType.DataHandling,
      summary: "This is a summary for Data Handling.",
      content: "Data Handling dolor sit amet");

  RPConsentSection locationSection = RPConsentSection(
      type: RPConsentSectionType.Location,
      summary: "This is a summary for Location.",
      content: "Location dolor sit amet");

  RPConsentSection healthSection = RPConsentSection(
      type: RPConsentSectionType.Health,
      summary: "This is a summary for Health.",
      content: "Health dolor sit amet");

  final healthDataCollectionSection = RPConsentSection(
    type: RPConsentSectionType.HealthDataCollection,
    summary: "ic.health.summary",
    dataTypes: [
      RPDataTypeSection(
        dataName: "ic.health.heartrate",
        dataInformation: "ic.health.heartrate.info",
      ),
      RPDataTypeSection(
        dataName: "ic.health.blood_glucose",
        dataInformation: "ic.health.blod_glucose.info",
      ),
      RPDataTypeSection(
        dataName: "ic.health.blood_pressure",
        dataInformation: "ic.health.blood_pressure.info",
      ),
      RPDataTypeSection(
        dataName: "ic.health.steps",
        dataInformation: "ic.health.steps.info",
      ),
    ],
  );

// Using keys for translations
  RPConsentSection userDataCollection = RPConsentSection(
      type: RPConsentSectionType.UserDataCollection,
      summary: "userDataCollection.summary",
      dataTypes: [
        RPDataTypeSection(
            dataName: "userDataCollection.alcohol.dataName",
            dataInformation: "userDataCollection.alcohol.dataInformation"),
        RPDataTypeSection(
            dataName: "userDataCollection.mood.dataName",
            dataInformation: "userDataCollection.mood.dataInformation"),
        RPDataTypeSection(
            dataName: "userDataCollection.weight.dataName",
            dataInformation: "userDataCollection.weight.dataInformation"),
        RPDataTypeSection(
            dataName: "userDataCollection.medications.dataName",
            dataInformation: "userDataCollection.medications.dataInformation"),
        RPDataTypeSection(
            dataName: "userDataCollection.smoking.dataName",
            dataInformation: "userDataCollection.smoking.dataInformation"),
      ]);

  RPConsentSection passiveDataCollection = RPConsentSection(
      type: RPConsentSectionType.PassiveDataCollection,
      summary:
          "This study will passively collect data about the following categories:",
      dataTypes: [
        RPDataTypeSection(
            dataName: "Steps",
            dataInformation:
                "Your daily step counts as collected by the phone."),
        RPDataTypeSection(
            dataName: "Activity",
            dataInformation:
                "Your different types of activities as detected by the phone"),
        RPDataTypeSection(
            dataName: "Location",
            dataInformation: "Your location as you move around"),
        RPDataTypeSection(
            dataName: "Noise",
            dataInformation:
                "Background noise as detected by the phone's microphone"),
      ]);

  RPConsentSection customSection = RPConsentSection(
    title: "Custom section",
    type: RPConsentSectionType.Custom,
    summary: "This is a summary for a Custom section.",
    content: "A Custom section dolor sit amet",
  );

  RPConsentSignature signature =
      RPConsentSignature(identifier: "consentSignatureID");

  // // Small version
  // RPConsentDocument consentDocument =
  //     RPConsentDocument(title: 'Informed Consent', sections: [
  //   overviewSection,
  //   aboutUs,
  //   dataGatheringSection,
  //   privacySection,
  //   timeCommitmentSection,
  //   userDataCollection,
  //   passiveDataCollection
  // ])
  //       ..addSignature(signature);

  // Full version
  RPConsentDocument consentDocumentAllSections = RPConsentDocument(
    title: 'Informed Consent - Full Version',
    sections: [
      overviewSection,
      welcomeSection,
      aboutUs,
      dataGatheringSection,
      privacySection,
      dataUseSection,
      timeCommitmentSection,
      durationSection,
      studyTasksSection,
      studySurveySection,
      withdrawingSection,
      yourRightsSection,
      goalsSection,
      benefitsSection,
      locationSection,
      healthSection,
      healthDataCollectionSection,
      userDataCollection,
      passiveDataCollection,
    ],
  )..addSignature(signature);

  RPConsentReviewStep consentReviewStep = RPConsentReviewStep(
    identifier: "consentreviewstepID",
    title: 'Consent Review',
    consentDocument: consentDocumentAllSections,
    reasonForConsent: 'informed_consent.agree_text',
    text: 'informed_consent.agree_confirm',
  );

  RPVisualConsentStep consentVisualStep = RPVisualConsentStep(
      identifier: "visualStep", consentDocument: consentDocumentAllSections);

  RPInstructionStep instructionStep = RPInstructionStep(
    identifier: "instructionID",
    title: "Welcome!",
    detailText:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ultricies feugiat turpis nec efficitur. Integer in pharetra libero. Proin a leo eu enim porttitor hendrerit. Suspendisse vestibulum interdum mollis. Donec in sapien ut orci ultricies laoreet. Ut maximus ante id arcu feugiat scelerisque. Proin non rutrum libero. Aliquam blandit arcu ac dolor consequat maximus. Integer et dolor quis quam tempor porta quis vel nibh. Phasellus ullamcorper fringilla lorem, ac tempus sem cursus a. Aliquam maximus facilisis quam. Morbi hendrerit tempor tellus, ac hendrerit augue tincidunt eu. Cras convallis lorem at nulla mattis tristique.",
    footnote: "(1) Important footnote",
    imagePath: "assets/images/waving-hand.png",
    // videoPath: "assets/video/colors.mp4",
    audioPath: "audio/test_audio.mp3",
    text: "informed_consent.welcome_text",
  );

  RPCompletionStep completionStep = RPCompletionStep(
    identifier: "completionID",
    title: "informed_consent.thanks",
    text: "informed_consent.document_saved",
  );

  RPOrderedTask consentTask = RPOrderedTask(
    identifier: "consentTaskID",
    steps: [
      instructionStep,
      consentVisualStep,
      consentReviewStep,
      completionStep,
    ],
  );

  return consentTask;
}

part of '../../../model.dart';

/// The [RPNavigableOrderedTask] class adds conditional step navigation to the
/// behavior inherited from the [RPOrderedTask] class.
/// It's able to show different questions based on previous answers by using
/// [RPStepNavigationRule]s.
/// This task allows participant to go back to/looping through previous questions.
/// In that case only the last answer given to the question will be saved.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPNavigableOrderedTask extends RPOrderedTask {
  /// A dictionary of step identifier Strings and their corresponding navigation
  /// rule([RPStepNavigationRule]).
  Map<String, RPStepNavigationRule> stepNavigationRules = {};

  late final List<RPStep> _definedSteps = List.of(steps);

  RPNavigableOrderedTask({
    required super.identifier,
    required super.steps,
    super.closeAfterFinished,
  });

  /// Returns the step after a specified step if there's any, taking the
  /// [RPStepNavigationRule]s into consideration.
  /// If the specified step is `null` then it returns the first step.
  /// Returns `null` if [step] was the last one in the sequence.
  @override
  RPStep? getStepAfterStep(RPStep? step, RPTaskResult? result) {
    step?.timer?.cancel();
    RPStep? stepToReturn;

    void returnNextQuestion() {
      int nextIndex = (step != null) ? steps.indexOf(step) + 1 : 0;

      if (nextIndex < steps.length) {
        stepToReturn = steps[nextIndex];
      } else {
        stepToReturn = null;
      }
    }

    if (step == null) {
      stepToReturn = steps.first;
      return stepToReturn;
    }

    if (stepNavigationRules.containsKey(step.identifier)) {
      RPStepNavigationRule rule = stepNavigationRules[step.identifier]!;

      switch (rule.runtimeType) {
        case const (RPStepReorganizerRule):
          RPStepReorganizerRule reorganizerRule = rule as RPStepReorganizerRule;
          RPStepResult? stepResult;
          if (step.runtimeType == RPFormStep) {
            RPTaskResult? recentTaskResult = blocTask.lastTaskResult;
            RPStepResult? foundStepResult;

            if (recentTaskResult != null) {
              recentTaskResult.results.forEach((key, stepResult) {
                if (stepResult is RPStepResult) {
                  try {
                    // ensure that we are looking up only until the first match
                    foundStepResult ??=
                        stepResult.getResultForIdentifier(step.identifier)
                            as RPStepResult;
                  } catch (e) {
                    print(
                        "No matching result found in this FormStep, proceeding to the next one (if any)");
                  }
                }
              });
            } else {
              throw ("Error: No task result is available");
            }
            stepResult = foundStepResult;
          } else {
            RPTaskResult? recentTaskResult = blocTask.lastTaskResult;
            RPStepResult foundStepResult;

            if (recentTaskResult != null) {
              foundStepResult = recentTaskResult
                  .getStepResultForIdentifier(step.identifier) as RPStepResult;
            } else {
              throw ("Error: No task result is available");
            }
            stepResult = foundStepResult;
          }

          List identifiersToKeep = [
            for (var choice in (stepResult!.results["answer"] as List<RPChoice>))
              reorganizerRule.reorderingMap[choice.value]!
          ];

          int triggerIndex = _definedSteps.indexOf(step);
          RPStep lastStep = _definedSteps.last;

          steps = [
            ..._definedSteps.take(triggerIndex + 1),
            ..._definedSteps
                .skip(triggerIndex + 1)
                .where((step) => identifiersToKeep.contains(step.identifier)),
            if (lastStep is RPCompletionStep &&
                !identifiersToKeep.contains(lastStep.identifier))
              lastStep,
          ];

          returnNextQuestion();

          break;
        case const (RPStepJumpRule):
          RPStepJumpRule jumpRule = (rule as RPStepJumpRule);
          RPStepResult? stepResult;
          if (step.runtimeType == RPFormStep) {
            RPTaskResult? recentTaskResult = blocTask.lastTaskResult;
            RPStepResult? foundStepResult;

            if (recentTaskResult != null) {
              recentTaskResult.results.forEach((key, stepResult) {
                if (stepResult is RPStepResult) {
                  try {
                    // ensure that we are looking up only until the first match
                    foundStepResult ??=
                        stepResult.getResultForIdentifier(step.identifier)
                            as RPStepResult;
                  } catch (e) {
                    print(
                        "No matching result found in this FormStep, proceeding to the next one (if any)");
                  }
                }
              });
            } else {
              throw ("Error: No task result is available");
            }
            stepResult = foundStepResult;
          } else {
            RPTaskResult? recentTaskResult = blocTask.lastTaskResult;
            RPStepResult foundStepResult;

            if (recentTaskResult != null) {
              foundStepResult = recentTaskResult
                  .getStepResultForIdentifier(step.identifier) as RPStepResult;
            } else {
              throw ("Error: No task result is available");
            }
            stepResult = foundStepResult;
          }

          String? answer =
              jumpRule.answerMap[stepResult!.results["answer"].first.value];

          bool hadStepId = false;
          for (var step in steps) {
            if (step.identifier == answer) {
              stepToReturn = step;
              hadStepId = true;
            }
          }
          if (!hadStepId) {
            returnNextQuestion();
          }

          break;
        case const (RPDirectStepNavigationRule):
          String destinationStepIdentifier =
              (rule as RPDirectStepNavigationRule).destinationStepIdentifier;
          for (var step in steps) {
            if (step.identifier == destinationStepIdentifier) {
              stepToReturn = step;
            }
          }
          break;
        default:
          throw ("Navigation Rule's type ${stepNavigationRules[step.identifier].runtimeType} is not a navigation rule type");
      }
    } else {
      returnNextQuestion();
    }

    return stepToReturn;
  }

  /// Adds a navigation rule to a step using its identifier.
  /// ```
  ///   RPNavigableOrderedTask navigableSurveyTask = RPNavigableOrderedTask(
  ///     "NavigableTaskID",
  ///     [
  ///       instructionStep,
  ///       questionStep1,
  ///       questionStep2,
  ///     ],
  ///   )
  ///   ..setNavigationRuleForTriggerStepIdentifier(someNavigationRule, questionStep1.identifier);
  /// ```
  void setNavigationRuleForTriggerStepIdentifier(
      RPStepNavigationRule stepNavigationRule, String triggerStepIdentifier) {
    stepNavigationRules[triggerStepIdentifier] = stepNavigationRule;
  }

  /// Returns the navigation rule for the given step identifier
  RPStepNavigationRule navigationRuleForTriggerStepIdentifier(
      String triggerStepIdentifier) {
    return stepNavigationRules[triggerStepIdentifier]!;
  }

  /// Removes the navigation rule from the given step using its identifier
  void removeNavigationRuleForTriggerStepIdentifier(
      String triggerStepIdentifier) {
    stepNavigationRules.remove(triggerStepIdentifier);
  }

  @override
  Function get fromJsonFunction => _$RPNavigableOrderedTaskFromJson;
  factory RPNavigableOrderedTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPNavigableOrderedTask>(json);
  @override
  Map<String, dynamic> toJson() => _$RPNavigableOrderedTaskToJson(this);
}

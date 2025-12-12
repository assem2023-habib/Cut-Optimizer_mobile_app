import '../../models/group_carpet.dart';

class GenerateResult {
  final List<GroupCarpet> groups;
  final int nextGroupId;

  GenerateResult(this.groups, this.nextGroupId);
}

class ProcessResult {
  final GroupCarpet group;
  final int nextGroupId;

  ProcessResult(this.group, this.nextGroupId);
}

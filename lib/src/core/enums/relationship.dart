enum Relationship {
  mother,
  father,
  sister,
  brother,
  wife,
  husband,
  other;

  String get name {
    switch (this) {
      case mother:
        return 'אמא';
      case Relationship.father:
        return 'אבא';
      case Relationship.sister:
        return 'אחות';
      case Relationship.brother:
        return 'אח';
      case Relationship.wife:
        return 'אישה';
      case Relationship.husband:
        return 'בעל';
      case Relationship.other:
        return 'אחר';
    }
  }
}

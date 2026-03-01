mixin ChartDataTable {
  static const kTable = 'ChartData';

  static const kTime = 'time';
  static const kLoad = 'load';

  static const schema = {
    'type': 'object',
    'required': [kTime, kLoad],
    'properties': {
      kTime: {'type': 'number', 'format': 'Double'},
      kLoad: {'type': 'number', 'format': 'Double'},
    },
  };

  static const getResponses = {
    '200': {
      'description': 'OK',
      'content': {
        'application/json': {
          'schema': {r'$ref': '#/components/schemas/$kTable'},
        },
      },
    },
    '5XX': {r'$ref': '#/components/responses/ServerError'},
  };

  static const postResponses = {
    '201': {
      'description': '$kTable created successfully!',
      'content': {
        'application/json': {
          'schema': {r'$ref': '#/components/schemas/$kTable'},
        },
      },
    },
    '400': {r'$ref': '#/components/responses/BadRequest'},
  };

  static const requestBody = {
    'required': true,
    'content': {
      'application/json': {
        'schema': {r'$ref': '#/components/schemas/$kTable'},
      },
    },
  };
}

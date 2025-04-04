import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

typedef FilterCallback<T> = PostgrestFilterBuilder<T> Function(
  PostgrestFilterBuilder<T> request,
);
typedef TransformCallback<T> = PostgrestTransformBuilder Function(
  PostgrestTransformBuilder request,
);

typedef StreamBuilderCallback<T> = SupabaseStreamBuilder Function(
  SupabaseStreamFilterBuilder request,
);

class AppDatabaseService {
  final SupabaseClient _client;

  AppDatabaseService({
    required SupabaseClient client,
  }) : _client = client;

  /// [insert] is equivalent to POST Request.
  /// [table] It's the reference to postgres table.
  /// [values] The data that needs to be posted in the document.
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  ///
  /// [filter] can also be used to make insert return the data that was inserted
  Future insert(
    String table, {
    required Object values,
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).insert(values);

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request;
    }

    return await transform(request);
  }

  /// [select] is equivalent to GET request that returns a list of data.
  /// [table] It's the reference to postgres table.
  /// [columns] The specific fields that you need, defaults to all ('*').
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  /// [transform] Is a function that gives you access to the request and allows you to transform your response
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).select(columns);

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request;
    }

    return await transform(request);
  }

  /// [countSelection] It's used to retrieve the total number of rows that satisfy the query. The value for count respects any filters (e.g. eq, gt), but ignores
  /// modifiers (e.g. limit, range).
  /// [table] It's the reference to postgres table.
  /// [columns] The specific fields that you need, defaults to all ('*').
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  /// [transform] Is a function that gives you access to the request and allows you to transform your response
  Future<(int count, List<Map<String, dynamic>> data)> countSelection(
    String table, {
    String columns = '*',
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).select(columns);

    if (filter != null) request = filter(request);

    if (transform == null) {
      final response = await request.count(CountOption.exact);
      return (response.count, response.data as List<Map<String, dynamic>>);
    }

    final response = await transform(request).count(CountOption.exact);

    return (response.count, response.data as List<Map<String, dynamic>>);
  }

  /// [selectSingle] is equivalent to GET Request that returns a single row of data.
  /// [table] It's the reference to postgres table.
  /// [columns] The specific fields that you need, defaults to all ('*').
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  /// [transform] Is a function that gives you access to the request and allows you to transform your response
  ///
  /// note that if you provide [transform] you must specify `request.single()` or `request.maybeSingle()` or you
  /// will get a format error
  Future<Map<String, dynamic>> selectSingle(
    String table, {
    String columns = '*',
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).select(columns);

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request.single();
    }

    return await transform(request);
  }

  /// [upsert] is equivalent to PUT Request.
  /// [table] It's the reference to postgres table.
  /// [columns] The specific fields that you need, defaults to all ('*').
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  ///
  /// [filter] can also be used to make insert return the data that was inserted
  Future upsert(
    String table, {
    required Object values,
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).upsert(values);

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request;
    }

    return await transform(request);
  }

  /// [update] is equivalent to PATCH Request, it throws an error if the data does not exists.
  /// [table] It's the reference to postgres table.
  /// [columns] The specific fields that you need, defaults to all ('*').
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  ///
  /// [filter] can also be used to make insert return the data that was inserted
  Future update(
    String table, {
    required Map values,
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).update(values);

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request;
    }

    return await transform(request);
  }

  /// [delete] is equivalent to DELETE Request.
  /// [table] It's the reference to postgres table.
  /// [columns] The specific fields that you need, defaults to all ('*').
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  ///
  /// [filter] can also be used to make insert return the data that was inserted
  Future delete(
    String table, {
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.from(table).delete();

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request;
    }

    return await transform(request);
  }

  /// ** Realtime streaming **
  /// Get a stream of changes to a table.
  /// it always returns the latest data `listen` called
  ///
  /// [table] It's the reference to postgres table.
  /// [primaryKey] Pass the list of primary key column names to [primaryKey], which supabase will use to update and delete the proper records internally as the stream receives real-time updates.
  /// [builderCallback] Is a function that gives you access to the streamBuilder and allows you to perform specific operations (e.g eq, neq, lte, gte..etc)
  Stream<List<Map<String, dynamic>>> stream(
    String table, {
    StreamBuilderCallback? builderCallback,
    required List<String> primaryKey,
  }) {
    final builder = _client.from(table).stream(primaryKey: primaryKey);

    if (builderCallback != null) return builderCallback(builder);

    return builder;
  }

  /// ** Remote Procedural Calls **
  /// Perform a stored procedure call for extra actions.
  ///
  /// [function] is the stored function
  /// [params] The specific parameters to be passed into the function.
  /// [filter] Is a function that gives you access to the request and allows you to perform filtering operations
  /// [transform] Is a function that gives you access to the request and allows you to transform your response
  Future rpc(
    String function, {
    Map<String, String>? params,
    FilterCallback? filter,
    TransformCallback? transform,
  }) async {
    PostgrestFilterBuilder request = _client.rpc(function, params: params);

    if (filter != null) request = filter(request);

    if (transform == null) {
      return await request;
    }

    return await transform(request);
  }
}

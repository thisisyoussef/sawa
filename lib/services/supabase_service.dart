import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    await dotenv.load();
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Generic data methods
  Future<List<Map<String, dynamic>>> getRecords(String table) async {
    final response = await _client.from(table).select();
    return response;
  }

  Future<Map<String, dynamic>> getRecordById(String table, int id) async {
    final response = await _client.from(table).select().eq('id', id).single();
    return response;
  }

  Future<Map<String, dynamic>> createRecord(
      String table, Map<String, dynamic> data) async {
    final response = await _client.from(table).insert(data).select();
    return response.first;
  }

  Future<Map<String, dynamic>> updateRecord(
      String table, int id, Map<String, dynamic> data) async {
    final response =
        await _client.from(table).update(data).eq('id', id).select();
    return response.first;
  }

  Future<void> deleteRecord(String table, int id) async {
    await _client.from(table).delete().eq('id', id);
  }
}

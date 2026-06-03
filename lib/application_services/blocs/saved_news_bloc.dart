import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/application_services/blocs/saved_news_event.dart';
import 'package:news_glance/application_services/blocs/saved_news_state.dart';
import 'package:news_glance/domain_models/news_article.dart';
import 'package:news_glance/domain_services/saved_news_persistence.dart';

@injectable
class SavedNewsBloc extends Bloc<SavedNewsEvent, SavedNewsState> {
  SavedNewsBloc(this._persistence) : super(const SavedNewsInitial()) {
    on<LoadSavedNews>(_onLoadSavedNews);
    on<ToggleSaveArticle>(_onToggleSaveArticle);
    on<RemoveSavedArticle>(_onRemoveSavedArticle);
  }

  final SavedNewsPersistence _persistence;

  Future<void> _onLoadSavedNews(
    LoadSavedNews event,
    Emitter<SavedNewsState> emit,
  ) async {
    emit(const SavedNewsLoading());
    try {
      final List<NewsArticle> articles = await _persistence.getSavedArticles();
      emit(SavedNewsLoaded(articles: articles));
    } catch (e) {
      emit(SavedNewsError(message: e.toString()));
    }
  }

  Future<void> _onToggleSaveArticle(
    ToggleSaveArticle event,
    Emitter<SavedNewsState> emit,
  ) async {
    try {
      final bool isCurrentlySaved = await _persistence.isSaved(
        event.article.urlSource,
      );
      if (isCurrentlySaved) {
        await _persistence.deleteArticle(event.article.urlSource);
      } else {
        await _persistence.saveArticle(event.article);
      }
      add(const LoadSavedNews());
    } catch (e) {
      emit(SavedNewsError(message: e.toString()));
    }
  }

  Future<void> _onRemoveSavedArticle(
    RemoveSavedArticle event,
    Emitter<SavedNewsState> emit,
  ) async {
    try {
      await _persistence.deleteArticle(event.urlSource);
      add(const LoadSavedNews());
    } catch (e) {
      emit(SavedNewsError(message: e.toString()));
    }
  }
}

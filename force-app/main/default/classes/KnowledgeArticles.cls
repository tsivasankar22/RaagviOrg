public with sharing class KnowledgeArticles {
    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getArticle() {
        return [SELECT Summary, Title, UrlName FROM Knowledge__kav];
    }
}
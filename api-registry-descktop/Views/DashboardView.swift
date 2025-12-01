//
//  DashboardView.swift
//  api-registry-descktop
//
//  Created by seregin-ma on 01.12.2025.
//

import SwiftUI
import Networking

struct DashboardView: View {
    @State var navigation: [String] = []
    
    let repository = RemoteRepository()
    @State var services = [ServiceResponse]()
    
    @State var viewData = DashboardViewData(totalServices: "0", activeServices: "0", endpoints: "0", depricated: "0")
    
    var body: some View {
        NavigationStack(path: $navigation) {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack { Spacer() }
                    Text("API Registry")
                        .font(.title)
                    Text("Центральный реестр микросервисов и API эндпоинтов")
                    Text("Быстрые действия")
                    HStack {
                        Button(action: {}) {
                            Text("Создать сервис")
                        }
                        
                        Button(action: {}) {
                            Text("Все сервисы")
                        }
                        
                        Button(action: {}) {
                            Text("Зависимости")
                        }
                        
                        Button(action: {}) {
                            Text("Базы данных")
                        }
                    }
                    Text("Статистика")
                    HStack {
                        Text("Всего сервисов")
                        
                        Text("Активные")
                        
                        Text("Эндпоинтов")
                        
                        Text("Устаревших")
                    }
                    
                    HStack {
                        Text("Последние сервисы")
                        Spacer()
                        Text("Посмотреть все -> ")
                    }
                }
            }
            .onAppear(perform: {
                loadServices()
            })
        }
        .frame(minWidth: 400, minHeight: 300)
    }
    
    func loadServices() {
        Task { @MainActor in
            do {
                services = try await repository.fetchServices()
                print(services.count)
                viewData.activeServices = services.count.description
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct DashboardViewData {
    var totalServices: String
    var activeServices: String
    var endpoints: String
    var depricated: String
}

#Preview {
    DashboardView()
}

enum ServicesAPI: APICall {
    var path: String { "/api/v1/services"}
    
    var method: String { "GET" }
    
    var headers: [String : String]? {
        ["Content-Type":"application/json"]
    }
    
    var query: [String : String]? { nil }
    
    func body() throws -> Data? {
        nil
    }
    
    case allServices
}

final class RemoteRepository: WebRepository {
    var session: URLSession = .shared
    
    var baseURL: String = "http://localhost:8080"
    
    var queue: DispatchQueue = DispatchQueue(label: "com.apiregistry.networking")
    
    let decoder = ProjectDecoder()
    
    func fetchServices() async throws -> [ServiceResponse] {
        try await call(endpoint: ServicesAPI.allServices, httpCodes: .success, decoder: decoder)
    }
    
}

final class ProjectDecoder: JSONDecoder {
    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}

struct CreateServiceRequest: Encodable {
    let name: String
    let description: String?
    let owner: String
    let tags: [String]
    let serviceType: ServiceType
    let supportsDatabase: Bool
    let proxy: Bool
}

struct UpdateServiceRequest: Encodable {
    let name: String?
    let description: String?
    let owner: String?
    let tags: [String]?
    let serviceType: ServiceType?
    let supportsDatabase: Bool?
    let proxy: Bool?
}

struct ServiceResponse: Decodable {
    let serviceId: UUID
    let name: String
    let description: String?
    let owner: String
    let tags: [String]
    let serviceType: ServiceType
    let supportsDatabase: Bool
    let proxy: Bool
    let createdAt: Date?
    let updatedAt: Date?
    let environments: [ServiceEnvironmentResponse]?
}

enum ServiceType: String, Codable, CaseIterable {
    case APPLICATION = "APPLICATION"
    case LIBRARY = "LIBRARY"
    case JOB = "JOB"
    case PROXY = "PROXY"
}

struct ServiceEnvironmentResponse: Decodable {
    let environmentId: UUID
    let serviceId: UUID
    let code: String
    let displayName: String
    let host: String
    let config: EnvironmentConfig?
    let status: EnvironmentStatus
    let createdAt: Date?
    let updatedAt: Date?
}

struct EnvironmentConfig: Codable {
    let timeoutMs: Int?
    let retries: Int?
    let downstreamOverrides: [String: String]?
}

enum EnvironmentStatus: String, Codable, CaseIterable {
    case ACTIVE = "ACTIVE"
    case INACTIVE = "INACTIVE"
}

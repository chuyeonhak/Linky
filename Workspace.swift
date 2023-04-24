import ProjectDescription
import ProjectDescriptionHelpers


// MARK: - Project

let workspace = Workspace(
    name: Project.Linky.name,
    projects: Module.allCases.map(\.path)
)

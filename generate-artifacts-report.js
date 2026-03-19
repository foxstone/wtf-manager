#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const ARTIFACTS_DIR = '/shared/foxstone/artifacts-temp';
const PROJECTS = ['legacy-api', 'ng-frontend', 'platform-api'];

function getFileStats(dir, basePath = '') {
    const results = [];
    
    if (!fs.existsSync(dir)) return results;
    
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    
    for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);
        const relativePath = path.join(basePath, entry.name);
        
        if (entry.isDirectory()) {
            results.push(...getFileStats(fullPath, relativePath));
        } else if (entry.isFile()) {
            const stats = fs.statSync(fullPath);
            results.push({
                name: relativePath,
                size: stats.size,
                created: stats.birthtime,
                modified: stats.mtime
            });
        }
    }
    
    return results;
}

function formatBytes(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function formatDate(date) {
    return date.toISOString().split('T')[0] + ' ' + date.toTimeString().split(' ')[0];
}

function generateReport() {
    const report = {
        timestamp: new Date().toISOString(),
        projects: {}
    };
    
    let totalFiles = 0;
    let totalSize = 0;
    
    for (const project of PROJECTS) {
        const projectDir = path.join(ARTIFACTS_DIR, project);
        const files = getFileStats(projectDir);
        
        const projectSize = files.reduce((sum, f) => sum + f.size, 0);
        
        report.projects[project] = {
            fileCount: files.length,
            totalSize: projectSize,
            totalSizeFormatted: formatBytes(projectSize),
            files: files.map(f => ({
                name: f.name,
                size: f.size,
                sizeFormatted: formatBytes(f.size),
                created: formatDate(f.created),
                modified: formatDate(f.modified)
            }))
        };
        
        totalFiles += files.length;
        totalSize += projectSize;
    }
    
    report.summary = {
        totalFiles,
        totalSize,
        totalSizeFormatted: formatBytes(totalSize)
    };
    
    return report;
}

const report = generateReport();

console.log('\n╔══════════════════════════════════════════════════════════════╗');
console.log('║              ARTIFACTS REPORT - ' + report.timestamp.split('T')[0] + '              ║');
console.log('╚══════════════════════════════════════════════════════════════╝\n');

for (const [project, data] of Object.entries(report.projects)) {
    console.log(`\n┌─────────────────────────────────────────────────────────────────`);
    console.log(`│ 📁 ${project.toUpperCase()}`);
    console.log(`├─────────────────────────────────────────────────────────────────`);
    console.log(`│ Files: ${data.fileCount}  |  Size: ${data.totalSizeFormatted}`);
    console.log(`├─────────────────────────────────────────────────────────────────`);
    
    if (data.files.length > 0) {
        for (const file of data.files) {
            console.log(`│   • ${file.name}`);
            console.log(`│     Size: ${file.sizeFormatted}  |  Modified: ${file.modified.split(' ')[0]}`);
        }
    } else {
        console.log(`│   (no files)`);
    }
    console.log(`└─────────────────────────────────────────────────────────────────`);
}

console.log(`\n┌─────────────────────────────────────────────────────────────────`);
console.log(`│ 📊 SUMMARY`);
console.log(`├─────────────────────────────────────────────────────────────────`);
console.log(`│ Total Files: ${report.summary.totalFiles}`);
console.log(`│ Total Size: ${report.summary.totalSizeFormatted}`);
console.log(`└─────────────────────────────────────────────────────────────────\n`);
